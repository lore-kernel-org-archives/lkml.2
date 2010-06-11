Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab0FKCCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:02:05 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:21572 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab0FKCCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:02:04 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,401,1272844800"; 
   d="scan'208";a="142807315"
From: Tom Lyon <pugs@lyon-about.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Date: Thu, 10 Jun 2010 18:58:37 -0700
User-Agent: KMail/1.9.9
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, mst@redhat.com,
       avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <20100610172736.GA9737@phenom.dumpdata.com>
In-Reply-To: <20100610172736.GA9737@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006101858.38491.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 June 2010 10:27:36 am Konrad Rzeszutek Wilk wrote:
> > +EXPORT_SYMBOL(uiommu_fdget);
> 
> EXPORT_SYMBOL_GPL
> .. snip
> > +EXPORT_SYMBOL(uiommu_put);
> 
> ditto.
> 

Is there a definitive explanation somewhere of when to use each?
