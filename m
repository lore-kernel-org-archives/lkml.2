Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1HLWDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:03:21 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:41014 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1HLWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:03:19 -0400
Date: Sat, 13 Aug 2011 00:03:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] ARM: zImage: Skip relinking if nothing changes
Message-ID: <20110812220316.GA28845@merkur.ravnborg.org>
References: <4E457682.5020107@codeaurora.org> <1313175602-21834-1-git-send-email-sboyd@codeaurora.org> <CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com> <20110812205520.GL4775@n2100.arm.linux.org.uk> <CACqU3MX=-10ouxCqWcBP7MW3_O4_RSLG9wRY8X4iEh5ydQa1AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MX=-10ouxCqWcBP7MW3_O4_RSLG9wRY8X4iEh5ydQa1AQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I suspect this would have done the job:
> 
> $(obj)/font.o: $(srctree)/drivers/video/console/font_acorn_8x8.c
>         $(cmd,cc_o_c)'

I prefer using $(call,shipped) and let kbuild figure out how
build an .o file from a .c file.

In other words - avoiding use of the internal to Makefile.build
variables in various places.

	Sam
