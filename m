Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1JYHII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:08:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43199 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab1JYHIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:08:07 -0400
Date: Tue, 25 Oct 2011 09:08:02 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] h8300: Move gpio.h to gpio-internal.h
Message-ID: <20111025070802.GA2919@opensource.wolfsonmicro.com>
References: <1319493561-4094-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <87sjmhr4wo.wl%ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjmhr4wo.wl%ysato@users.sourceforge.jp>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 02:55:51PM +0900, Yoshinori Sato wrote:

> I will moving generic GPIO.

Excellent news!  I'm hoping this week to post some further patches which
make this a little easier by making a default version of asm/gpio.h
available.  Hopefully we'll also be able to turn on optional gpiolib
support for all architectures which should mean that all that's required
is a new driver for the CPU under drivers/gpio.
