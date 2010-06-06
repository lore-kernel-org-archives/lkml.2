Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0FFTAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:00:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57844 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab0FFTAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:00:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
Date: Sun, 6 Jun 2010 21:01:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Vitaly Wool <vitalywool@gmail.com>, Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
References: <AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com> <AANLkTim0JD4V0RTc6CRIADypqYhQo3JYp3dJs0l7g7Ps@mail.gmail.com> <20100606173146.GA13432@srcf.ucam.org>
In-Reply-To: <20100606173146.GA13432@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006062101.52752.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 June 2010, Matthew Garrett wrote:
> On Sun, Jun 06, 2010 at 07:21:49PM +0200, Vitaly Wool wrote:
> > 2010/6/6 Matthew Garrett <mjg59@srcf.ucam.org>:
> > 
> > > Suspend blocks prevent system suspend, not any per-device suspend.
> > 
> > Can you suspend a device which is holding a wake lock?
> 
> Yes. Suspend blocks are orthogonal to runtime PM.

Yes, they are.

The idea that they would somehow interfere with runtime PM has always been pure
nonsense.  They wouldn't and there's no way in which they could.

Whether or not they are really necessary to address the Android requirements is
a different question, though, and I don't really think so right now.  At least
not in the form submitted by Arve.

Also, there's some overlap between suspend blockers and the PM QoS framework,
so it seems to be a good idea to extend PM QoS (which already is in the kernel)
to express some requirements that suspend blockers are supposed to express.

Rafael
