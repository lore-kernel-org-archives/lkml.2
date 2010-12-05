Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab0LEQKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 11:10:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57336 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab0LEQKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 11:10:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 5 Dec 2010 17:09:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [Regression] firewire_ohci causes system resume to fail
Message-ID: <20101205170947.6b4e2d09@stein>
In-Reply-To: <20101205161758.2d75c65d@stein>
References: <201012051542.31826.rjw@sisk.pl>
	<20101205161758.2d75c65d@stein>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 05 Stefan Richter wrote:
> On Dec 05 Rafael J. Wysocki wrote:
> > There is a regression I can reproduce 100% of the time on a AMD-based desktop
> > box that resume from hibernation (or suspend) fails because of the firewire_ohci
> > module.  The box just hangs when firewire_ohci resume runs, apparently, and it
> > is sufficient to do:
> > 
> > # echo devices > /sys/power/pm_test
> > # echo disk > /sys/power/state
> > 
> > to reproduce the issue.
> 
> Do you have anything attached to the FireWire bus?  What controller do
> you have?

I just now tested the above on an Intel Mac mini, running
unmodified 2.6.37-rc4 x86-32, without and with a camera on the FireWire
port, and could not reproduce the problem.  I also got an AMD based PC
here with an array of different FireWire controllers which I shall make
available to the same test...
-- 
Stefan Richter
-=====-==-=- ==-- --=-=
http://arcgraph.de/sr/
