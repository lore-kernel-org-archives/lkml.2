Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab2DKQAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:00:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54815 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758884Ab2DKP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:59:59 -0400
X-Sasl-enc: K1rd23+k+Iy/YRbp+PcOj25UlIWNdaijEkLEiKB0ZEPh 1334159998
Date: Wed, 11 Apr 2012 08:59:57 -0700
From: Greg KH <greg@kroah.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, jan.kiszka@siemens.com, mtosatti@redhat.com
Subject: Re: [PATCH v2 0/2] kvm: iommu unmap fixes
Message-ID: <20120411155957.GA31288@kroah.com>
References: <20120411154536.13227.10413.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411154536.13227.10413.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:51:43AM -0600, Alex Williamson wrote:
> This is a documentation change only from the previous version.
> After discussing it, there is a potential page leak as noted
> in the updated changelog for the first patch.  Thanks,

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
