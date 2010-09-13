Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0IMUrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:47:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1955 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0IMUrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:47:47 -0400
Subject: Re: [PATCH 24/25] sound: Use static const char arrays
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel <alsa-devel@alsa-project.org>
In-Reply-To: <s5h1v8xl73g.wl%tiwai@suse.de>
References: <cover.1284406638.git.joe@perches.com>
	 <d0ef4062f24ff95c6f7d44a9123e19c17e712744.1284406639.git.joe@perches.com>
	 <s5h1v8xl73g.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 13:47:45 -0700
Message-ID: <1284410865.26719.88.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 22:30 +0200, Takashi Iwai wrote:
> At Mon, 13 Sep 2010 12:48:02 -0700,
> Joe Perches wrote:
> > diff --git a/sound/core/misc.c b/sound/core/misc.c
> > -	char tmp[] = "<0>";
> > +	char tmp[sizeof("<0>")];
> Would this case save something really...?

Not really.  It's the same x86 code size with different opcodes.
It's just a stupid checkpatch future warning avoidance change.
Ignore it at your pleasure.

cheers, Joe

