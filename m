Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0FONoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:44:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27642 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0FONoF (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Jun 2010 09:44:05 -0400
Date: Mon, 14 Jun 2010 17:20:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, ddutile@redhat.com,
       sheng@linux.intel.com
Subject: Re: [Xen-devel] [PATCH 06/12] Allow xen platform pci device to be
 compiled as a module
Message-ID: <20100614212046.GD8600@phenom.dumpdata.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1275570645-27189-6-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275570645-27189-6-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4C178393.01A0:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static inline unsigned int max_nr_grant_frames(void)
> +unsigned int gnttab_max_nr_grant_frames(void)
>  {
>  	unsigned int xen_max = __max_nr_grant_frames();
>  
> @@ -444,6 +445,7 @@ static inline unsigned int max_nr_grant_frames(void)
>  		return boot_max_nr_grant_frames;
>  	return xen_max;
>  }
> +EXPORT_SYMBOL_GPL(gnttab_max_nr_grant_frames);

Prefix the name with 'xen_' ? That is a mouthfull thought:

Xen Grant Table Max Nr Grant Frames. How about 'xen_gnttab_max_frames' ?

