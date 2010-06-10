Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab0FJRaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:30:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33599 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312Ab0FJR36 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Jun 2010 13:29:58 -0400
Date: Thu, 10 Jun 2010 13:27:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tom Lyon <pugs@cisco.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, mst@redhat.com,
       avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100610172736.GA9737@phenom.dumpdata.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C1120FE.0158:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +EXPORT_SYMBOL(uiommu_fdget);

EXPORT_SYMBOL_GPL
.. snip
> +EXPORT_SYMBOL(uiommu_put);

ditto.
