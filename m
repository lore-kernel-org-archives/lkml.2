Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0FXNFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:05:13 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:33486 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754810Ab0FXNFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:05:10 -0400
Date: Thu, 24 Jun 2010 18:35:03 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/6 V3] mfd/stmpexxx: fix stmpe811 enable hook
Message-ID: <20100624130502.GF26189@bnru02.bnr.st.com>
References: <20100624123211.GB3988@pengutronix.de>
 <1277383678-4973-1-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1277383678-4973-1-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 14:47:58 +0200, Luotao Fu wrote:
> Fix the stmpe811 enable hook so that we can activate the needed clocks for the
> touchscreen controller.
> 
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
