Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab0DATIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:08:48 -0400
Received: from www.tglx.de ([62.245.132.106]:37743 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab0DATIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:08:43 -0400
Date: Thu, 1 Apr 2010 21:08:21 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Tom Lyon <pugs@lyon-about.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
 non-privileged processes
Message-ID: <20100401190821.GJ2045@bluebox.local>
References: <201003311708.38961.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003311708.38961.pugs@lyon-about.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 05:08:38PM -0700, Tom Lyon wrote:
> uio_pci_generic has previously been discussed on the KVM list, but this patch 
> has nothing to do with KVM, so it is also going to LKML.

Just a side note: It would be nice if you Cc:'ed the UIO maintainers (Greg
and me) on patches like that. UIO is an actively maintained framework in the
kernel.

Thanks,
Hans

