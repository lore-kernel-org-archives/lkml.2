Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0I3WAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 18:00:36 -0400
Received: from www.tglx.de ([62.245.132.106]:51087 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab0I3WAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 18:00:35 -0400
Date: Fri, 1 Oct 2010 00:00:23 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] uio: Simplify the lifetime logic of struct
 uio_device.
Message-ID: <20100930220023.GB4337@local>
References: <20100917205946.GF2522@local>
 <m139t451b4.fsf_-_@fess.ebiederm.org>
 <20100924104555.GC1819@silverbox.local>
 <m1hbhfcbdo.fsf@fess.ebiederm.org>
 <20100924173106.GA4966@silverbox.local>
 <m14ode662q.fsf@fess.ebiederm.org>
 <20100925003308.GA29910@suse.de>
 <m1wrqa4mg5.fsf@fess.ebiederm.org>
 <20100926192142.GA7252@kroah.com>
 <m162xs9l7j.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m162xs9l7j.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 03:46:56PM -0700, Eric W. Biederman wrote:
> 
> Embed struct device into struct uio_device, and use
> the refcounting and the release method of struct device
> to control struct uio_device.
> 
> This allows device_create and device_destroy to be replaced
> with the more standard device_register and device_unregister,
> and allows the struct device reference count to act as a
> reference count on struct idev as well.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Eric,
just to give you a feedback: I simply didn't find the time to have a look
at your patches. I have a 200% workload ATM in my daily job. I hope I can
have a look at the weekend.

Sorry for the delay, but you're not forgotten ;-)

Thanks,
Hans

