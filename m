Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab0EVR7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:59:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab0EVR64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:58:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current -git
Date: Sat, 22 May 2010 20:00:15 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <201005212343.25184.rjw@sisk.pl> <201005221934.09705.rjw@sisk.pl> <20100522175221.GA26778@liondog.tnic>
In-Reply-To: <20100522175221.GA26778@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005222000.15826.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010, Borislav Petkov wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sat, May 22, 2010 at 07:34:09PM +0200
> 
> > > Rafael, can you check whether the C1E idle is selected.
> > 
> > Can you please remind me how I can check that?
> 
> look for
> 
> "using C1E aware idle routine"

Yes, it prints that.

Rafael
