Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0FXMns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:43:48 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:34704 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017Ab0FXMnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:43:47 -0400
Date: Thu, 24 Jun 2010 18:13:07 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 1/6] gpio/stmpe-gpio: set GPIO alternate function while
 requesting
Message-ID: <20100624124307.GD26189@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
 <1277378021-16802-2-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1277378021-16802-2-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 13:13:36 +0200, Luotao Fu wrote:
> add reuqest hook to the gpio chip, so that we can make sure that the GPIO pin is
> setted to the correct GPIO alternate function after we have requested the GPIO
> pin.
> 
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
