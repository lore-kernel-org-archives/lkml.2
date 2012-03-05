Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab2CETXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:23:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757338Ab2CETXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:23:46 -0500
Date: Mon, 5 Mar 2012 14:23:38 -0500
From: Dave Jones <davej@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WARNING: Adjusting tsc more then 11%
Message-ID: <20120305192338.GA30491@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	John Stultz <john.stultz@linaro.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20120305154411.GA29668@redhat.com>
 <1330972323.2191.74.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330972323.2191.74.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 10:32:03AM -0800, John Stultz wrote:
 > On Mon, 2012-03-05 at 10:44 -0500, Dave Jones wrote:

 > > any idea what could have changed to start tripping that up ?
 > > 
 > > The reports seem to have started around 3.3-rc4.
 > 
 > Huh. No I don't know what would have started causing such a warning. I
 > had expected that there would be some edge hardware that might trip that
 > warning, but I'd expect the noise to start there w/ 3.2 after it was
 > introduced. There's only been spelling & comment changes to the
 > timekeeping core in the 3.3-rc series.

thinking about this some more, while the reports starts around rc4, this
may have been caused by something prior to that, as anyone moving from
Fedora 16 or earlier to F17 alpha would have jumped quite a kernel version or two.

 > Do you know if this is an occasional thing on any of the affected
 > hardware, or if it happens after every reboot?

Out of all the people running the Fedora 17 alpha, this has only shown
up those four times, so it does seem to be a rare thing.
I suspect we'll get more instances of it as more people start testing.

Three of the reporters noted that it happened on boot.

 > Are any of the reported boxes systems you have access to in order to
 > reproduce?

unfortunately not.

	Dave

