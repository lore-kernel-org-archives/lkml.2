Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab1F3PWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:22:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35752 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751294Ab1F3PWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:22:12 -0400
Date: Thu, 30 Jun 2011 08:22:07 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: alsa-devel@alsa-project.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/5] ASoC: wm8731: rework power management
Message-ID: <20110630152203.GB3249@opensource.wolfsonmicro.com>
References: <1309370419-22810-1-git-send-email-nicolas.ferre@atmel.com>
 <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com>
 <20110629171148.GB10798@opensource.wolfsonmicro.com>
 <4E0C80B8.7030006@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0C80B8.7030006@atmel.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 03:57:12PM +0200, Nicolas Ferre wrote:

Please fix your mailer to line wrap within paragraphs.

> First of all, I experienced issues while not having OSC enabled during
> suspend/resume cycle. Am I right supposing that, if using oscillator
> to clock the codec, I have to keep it running during a suspend/resume
> cycle?

No, not at all.  What makes you believe that you would you need to do
that?
