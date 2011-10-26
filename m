Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab1JZObJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:31:09 -0400
Received: from seven.medozas.de ([188.40.89.202]:43273 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096Ab1JZObI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:31:08 -0400
Date: Wed, 26 Oct 2011 16:31:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: NeilBrown <neilb@suse.de>
cc: Alan Stern <stern@rowland.harvard.edu>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
In-Reply-To: <20111021162340.669742c0@notabene.brown>
Message-ID: <alpine.LNX.2.01.1110261625370.15209@frira.zrqbmnf.qr>
References: <20111020111743.13b40558@notabene.brown> <Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org> <20111021162340.669742c0@notabene.brown>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2011-10-21 07:23, NeilBrown wrote:
>At:
>    git://neil.brown.name/lsusd
>or
>    http://neil.brown.name/git/lsusd
>
>you can find a bunch of proof-of-concept sample code that implements a
>"Linux SUSpend Daemon" with client support library and test programs.
>
>  lsused:
>      lsused (which needs a better name) listens on the socket
>            /var/run/suspend/registration

(lx)suspd and (lx)susp_eventd?
NB: The short form of Linux is usually lx (not l). Also, yours would be
the first I know to explicitly contain l/lx, which I think is rather
redundant, given I'll never run a type of suspend other than the linux
one anyway.
