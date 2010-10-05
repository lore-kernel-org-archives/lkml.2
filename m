Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0JEUff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:35:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52286 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0JEUfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:35:34 -0400
To: Takashi Iwai <tiwai@suse.de>
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
In-reply-to: <s5hwrpxnf41.wl%tiwai@suse.de> (message from Takashi Iwai on Tue,
	05 Oct 2010 11:49:50 +0200)
Subject: Re: [REGRESSION] no sound on T60 laptop (HDA Intel)
References: <E1P33mT-0003qa-Fv@pomaz-ex.szeredi.hu> <s5hwrpxnf41.wl%tiwai@suse.de>
Message-Id: <E1P3EES-0005SV-Sr@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 05 Oct 2010 22:35:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Oct 2010, Takashi Iwai wrote:
> In anyway, if this is reproducible, get alsa-info.sh output before and
> after suspend.  It'll give more information of HD-audio and sound
> driver status.

No significant difference before and after the suspend

...

Bisected it to commit 3f50ac6a0e "ALSA: hda - Fix stream and
channel-ids codec-bus wide"

Reverting this on latest git fixes the sound.

Thanks,
Miklos
