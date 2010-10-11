Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0JKM7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:59:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60047 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754498Ab0JKM7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:59:36 -0400
Date: Mon, 11 Oct 2010 13:59:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8804: fix error handling code
Message-ID: <20101011125934.GM9231@rakim.wolfsonmicro.main>
References: <1286731745-18169-1-git-send-email-segooon@gmail.com>
 <20101011120014.GJ9231@rakim.wolfsonmicro.main>
 <20101011121555.GA32652@albatros>
 <20101011123609.GL9231@rakim.wolfsonmicro.main>
 <20101011125056.GA25041@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011125056.GA25041@albatros>
X-Cookie: Help a swallow land at Capistrano.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 04:50:56PM +0400, Vasiliy Kulikov wrote:

> It is not greppable situation to simply change the behavior of all
> drivers.  I was looking for memory leak bugs in drivers/net/ and fixed
> some of them.  Manual looking through _all_ drivers takes much more
> time.  In general I try to search for repeatable bugs with coccinelle,
> but it is rare case.

The method you're using to generate the patches is pretty much
orthogonal to anything else, except of course in the case where you're
also submitting the automation for checking (which is useful where
possible).
