Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1KXTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:09:27 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:58493 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1KXTJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:09:24 -0500
Message-ID: <1322161754.25125.72.camel@x61.thuisdomein>
Subject: Re: [PATCH] ASoC: samsung: drop unknown Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 Nov 2011 20:09:14 +0100
In-Reply-To: <20111124172216.GR8470@opensource.wolfsonmicro.com>
References: <1322155037.25125.61.camel@x61.thuisdomein>
	 <20111124172216.GR8470@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 17:22 +0000, Mark Brown wrote:
> On Thu, Nov 24, 2011 at 06:17:17PM +0100, Paul Bolle wrote:
> There's people somewhat actively working on the OpenMoko devices out of
> tree (and I personally have a GTA01) and I'd rather not do anything that
> causes any more hassle for them.

I don't own a GTA01. Neither do I like to cause hassle for the people
working on OpenMoko.

But the history of the code my patch drops, seems to start with
(mainline) commits 74930bb6db ("[ALSA] ASoC S3C24xx machine drivers -
Openmoko Neo1973") and 80ab1c0e9e ("[ALSA] ASoC S3C24xx machine drivers
- Kconfig"), both dated May 14, 2007. So I'm touching code here that has
been unbuildable (in the mainline tree) for over four years. Isn't that
in itself sufficient to drop this code (and the incomplete kbuild stuff
supporting it)?

> I'd suggest discussing this with the OpenMoko guys if you want to do it.

Who would that be?


Paul Bolle

