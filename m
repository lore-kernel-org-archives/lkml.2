Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2G0QxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:53:02 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35287 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2G0Qw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:52:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120709074158.GS30009@pengutronix.de>
References: <1341606020-26449-1-git-send-email-fabio.estevam@freescale.com>
	<20120709074158.GS30009@pengutronix.de>
Date: Fri, 27 Jul 2012 13:52:58 -0300
Message-ID: <CAOMZO5D+W_VwW=oQaSanogU=9yT=86hV1UN+M3-8JEo0_S9fDQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] hw_random: mxc-rnga: Adapt clocks to new i.mx clock framework
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 4:41 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Uhh, that's a driver bug that should be fixed. Although right now there
> is no reference counting for clocks, the driver should keep the clk
> internally instead of simply calling clk_get whenever it needs access to
> a clk.

Yes, I just sent a fix for this.
