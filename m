Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab0JSANg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:13:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47358 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752133Ab0JSANf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:13:35 -0400
Date: Mon, 18 Oct 2010 16:31:45 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sound/soc/davinci/davinci-mcasp.c: Return error
 code in failure
Message-ID: <20101018233112.GA26745@opensource.wolfsonmicro.com>
References: <1287411074-19825-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287411074-19825-1-git-send-email-julia@diku.dk>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 04:11:13PM +0200, Julia Lawall wrote:
> In this code, 0 is returned on failure, even though other
> failures return -ENOMEM or other similar values.

Applied, thanks.
