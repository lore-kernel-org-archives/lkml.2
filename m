Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab1HMKt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 06:49:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60483 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1HMKtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 06:49:25 -0400
Subject: Re: 3.0.1-rt9 regression: Build is now broken on
 migrate_[dis|en]able (on ARM)
From: Peter Zijlstra <peterz@infradead.org>
To: Remy Bohmer <linux@bohmer.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Sat, 13 Aug 2011 12:48:55 +0200
In-Reply-To: <CANqCtQJ11VjF0S8phC5NOZMuuu5mjdsHHXAj_xUeos+NSjPFCg@mail.gmail.com>
References: <CANqCtQJ11VjF0S8phC5NOZMuuu5mjdsHHXAj_xUeos+NSjPFCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313232535.25267.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-13 at 12:14 +0200, Remy Bohmer wrote:
> FYI: These patches probably are the reason that RT9 broke our build,
> that worked on RT8, please find attached my .config
> Maybe I can come up with a fix tomorrow if I can find some time to
> look into.
> 
> 
Wheee, SMP=n builds are what I ever forget ;-)

Should be fixed in -rt11
