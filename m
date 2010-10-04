Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0JDJYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:24:54 -0400
Received: from www.tglx.de ([62.245.132.106]:37628 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0JDJYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:24:53 -0400
Date: Mon, 4 Oct 2010 11:26:26 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] uio: Remove unused uio_info mmap method.
Message-ID: <20101004092625.GA1867@silverbox.local>
References: <20100917205946.GF2522@local>
 <m139t451b4.fsf_-_@fess.ebiederm.org>
 <20100924104555.GC1819@silverbox.local>
 <m1hbhfcbdo.fsf@fess.ebiederm.org>
 <20100924173106.GA4966@silverbox.local>
 <m14ode662q.fsf@fess.ebiederm.org>
 <20100925003308.GA29910@suse.de>
 <m1wrqa4mg5.fsf@fess.ebiederm.org>
 <20100926192142.GA7252@kroah.com>
 <m1tylc86ks.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tylc86ks.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 03:48:19PM -0700, Eric W. Biederman wrote:
> 
> There are no drivers in the kernel that implement the uio_info mmap
> method there is no point in keeping it.
> 
> Further keeping the mmap method would necessiate wrapping all of the
> methods in vm_operations_struct to successfully implement suppport
> for hotunplugable hardware, and it I have yet to find a correct way to
> wrap the the vm_operations_struct close method.

I have no objections, but please update Documentation/DocBook/uio-howto.tmpl
accordingly.

Thanks,
Hans

