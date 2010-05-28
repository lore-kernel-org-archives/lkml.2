Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab0E1K65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:58:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:45486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab0E1K6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:58:51 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Chan <mike@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Arve@smtp1.linux-foundation.org,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com
In-Reply-To: <AANLkTik-8HtTVOh3toXBZZlXYgDTFtfkm6EDYRw-UPm4@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	 <201005280041.43553.rjw@sisk.pl>
	 <20100528001514.28e593ef@lxorguk.ukuu.org.uk>
	 <201005280205.01561.rjw@sisk.pl>
	 <AANLkTik-8HtTVOh3toXBZZlXYgDTFtfkm6EDYRw-UPm4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 09:47:49 +0200
Message-ID: <1275032869.32462.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 17:49 -0700, Mike Chan wrote:
> Even if we used the proposed QoS replacement, are there suggestions on
> how to keep the cpu idle for longer than 2 seconds in Linux without
> using suspend?

What exactly is stopping it from being idle?

