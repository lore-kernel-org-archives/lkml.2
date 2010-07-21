Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0GUMzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:55:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40627 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752371Ab0GUMzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:55:16 -0400
Date: Wed, 21 Jul 2010 13:55:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: Missing config option for SFFSDR_FPGA
Message-ID: <20100721125514.GC15462@rakim.wolfsonmicro.main>
References: <86tynthzja.fsf@peer.zerties.org>
 <20100721122853.GA15462@rakim.wolfsonmicro.main>
 <s5htynt2eum.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htynt2eum.wl%tiwai@suse.de>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 02:34:25PM +0200, Takashi Iwai wrote:

> The problem is that the drivers for embedded platforms are often out
> of sync.  davinci is one of such platforms.  So, as Mark suggested,
> it'd be better to talk with guys responsible for such a system
> beforehand.

> Of course, as upstream, we can clean up things here.  But, I'd like to
> see this clean-up rather from the platform side.  In that way, it can
> be synchronized better.

More generally nobody who doesn't have the board is going to care about
things in a board-specific file too much, and with a lot of boards
there's substantial code carried out of tree that's not yet made it into
mainline for one reason or another.
