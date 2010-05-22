Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab0EVRw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:52:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47647 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863Ab0EVRw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:52:27 -0400
Date: Sat, 22 May 2010 19:52:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current
 -git
Message-ID: <20100522175221.GA26778@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	John Stultz <johnstul@us.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <201005212343.25184.rjw@sisk.pl>
 <alpine.LFD.2.00.1005221429360.3368@localhost.localdomain>
 <alpine.LFD.2.00.1005221616310.3368@localhost.localdomain>
 <201005221934.09705.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201005221934.09705.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, May 22, 2010 at 07:34:09PM +0200

> > Rafael, can you check whether the C1E idle is selected.
> 
> Can you please remind me how I can check that?

look for

"using C1E aware idle routine"

in dmesg.

-- 
Regards/Gruss,
    Boris.
