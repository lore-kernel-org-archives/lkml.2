Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0DIQsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:48:05 -0400
Received: from 8bytes.org ([88.198.83.132]:56024 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab0DIQsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:48:01 -0400
Date: Fri, 9 Apr 2010 18:48:00 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access
	for?non-privileged processes
Message-ID: <20100409164800.GG8750@8bytes.org>
References: <201003311708.38961.pugs@lyon-about.com> <20100402170515.GA32579@suse.de> <4BBEFA3B.8070609@redhat.com> <201004090934.16891.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004090934.16891.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 09:34:16AM -0700, Tom Lyon wrote:
> The 'check' items are already done, not fully tested; probably available next week.
> Can we leave the others for future patches? Please? And I definitely need help with 
> the PCI config stuff.

Yeah, go in small steps forward. Just post again what you have next
week. We can add more functionality step by step.

	Joerg

