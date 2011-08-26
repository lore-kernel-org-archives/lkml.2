Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1HZQMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:12:02 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32315 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab1HZQMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:12:00 -0400
Date: Fri, 26 Aug 2011 12:11:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, JBeulich@novell.com,
        stable@kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 1/5] xen-pcifront: Update warning comment
 to use 'e820_host' option.
Message-ID: <20110826161127.GA29706@dumpdata.com>
References: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
 <1314225096-4861-2-git-send-email-konrad.wilk@oracle.com>
 <1314225693.15882.13.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314225693.15882.13.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E57C5C8.00DA:SCFMA922111,ss=1,re=-0.101,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  				dev_err(&pdev->xdev->dev, "Could not claim resource %s/%d! "
> 					"Device offline. Try using e820_host=1 in the guest config.\n",
> 

Done. Picked the one above. Thanks!
