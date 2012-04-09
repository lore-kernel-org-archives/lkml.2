Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2DIACV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 20:02:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab2DIACV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 20:02:21 -0400
Date: Mon, 9 Apr 2012 02:02:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Trivial] Delete trailing whitespace from
 sound/soc/codecs/wm8994.c
In-Reply-To: <alpine.LNX.2.00.1204090038270.11747@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204090201160.24006@pobox.suse.cz>
References: <alpine.LNX.2.00.1204090038270.11747@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Jesper Juhl wrote:

> While reading through sound/soc/codecs/wm8994.c I noticed a fair
> amount of trailing whitespace. This patch gets rid of it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Jesper,

is it really worth it? The code should have been fixed before merging, 
yes, but once it's there, such fixups tend to only make people angry 
(because they have to do unnecessary extra steps during git blame).

-- 
Jiri Kosina
SUSE Labs
