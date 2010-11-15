Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab0KOTOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:14:22 -0500
Received: from mail.perches.com ([173.55.12.10]:1319 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933505Ab0KOTOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:14:21 -0500
Subject: Re: [PATCH 44/44] sound/soc/codecs: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101115190738.GF3338@sirena.org.uk>
References: <cover.1289789604.git.joe@perches.com>
	 <97fd199b7dac50613f6843156687223928cce44a.1289789605.git.joe@perches.com>
	 <20101115134939.GC12986@rakim.wolfsonmicro.main>
	 <1289840957.16461.138.camel@Joe-Laptop>
	 <20101115173031.GI12986@rakim.wolfsonmicro.main>
	 <1289842444.16461.140.camel@Joe-Laptop>
	 <20101115182708.GJ12986@rakim.wolfsonmicro.main>
	 <1289845830.16461.149.camel@Joe-Laptop>
	 <20101115190738.GF3338@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 11:14:18 -0800
Message-ID: <1289848458.16461.150.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 19:07 +0000, Mark Brown wrote:
> I'd suggest using pattern matching to look up the
> rules for generating the prefixes (it's pretty much entirely prefixes)
> in the same way you're handling figuring out who to mail - that'd
> probably cover it in an automatable fashion.

Publish a tool that works and I'll use it.


