Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab1ERQ0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:26:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55483 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932387Ab1ERQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:25:58 -0400
Date: Wed, 18 May 2011 09:25:58 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Bibek BASU <bibek.basu@stericsson.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Juergen Beisert <jbe@pengutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Smartcard/SIM card subsystem, LDO regulator and signal modelling
Message-ID: <20110518162558.GA16414@opensource.wolfsonmicro.com>
References: <BANLkTikAzjmVoNK20RHRkhHkn3YgSra6dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikAzjmVoNK20RHRkhHkn3YgSra6dA@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:36:17PM +0200, Linus Walleij wrote:

> It's basically an LDO for powering a SIM card (which in turn is basically
> a smartcard), but apart from plain regulation also expose some other
> electrical properties of the interface to software:

> - Select pull-up resistance on some I/O lines
> - Select weak pull-down on some data lines
> - Select load capacitance limits on the data lines
> - Select whether to run in low impedance or transmission gate mode

> I think these will be mostly similar so what other SIM card controllers
> will need to have. All the stuff needs to have userspace interfaces
> since the stuff is usually controlled on behalf of another CPU
> running the modem (and also performing the actual traffic on
> the SIM data lines).

The above also sounds rather like the standard sort of stuff you get
with pin muxes - the pulls are certainly very common for random GPIO
or I2C use, for example.  No real idea on the SIM interface itself.
