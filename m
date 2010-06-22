Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab0FVN4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:56:46 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:54317 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758321Ab0FVN4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:56:44 -0400
Date: Tue, 22 Jun 2010 19:26:36 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "l.fu@pengutronix.de" <l.fu@pengutronix.de>
Subject: Re: [PATCH 1/3] mfd: add STMPExxxx I/O Expander support
Message-ID: <20100622135635.GA30720@bnru02.bnr.st.com>
References: <1275308236-1775-1-git-send-email-rabin.vincent@stericsson.com>
 <20100618234222.GL3582@sortiz.org>
 <20100621133305.GA2744@bnru02.bnr.st.com>
 <20100621154514.GA416@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100621154514.GA416@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 17:45:14 +0200, Luotao Fu wrote:
> I'll test the patch as soon as I can. Do you have any public GIT tree
> with the stmpexxx stuffs in them, so that I might be able to merge it
> with my board stuffs directly?

Sorry, no, I don't have a git tree.  I've posted the updated version
just now, you only need to grab the first two since the keypad doesn't
exist on 811.  Please see if you can get this to work on 811.  I've
already ported over some of the delta features from your driver.
Thanks.

Rabin
