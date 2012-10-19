Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab2JSTya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:54:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50019 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab2JSTy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:54:29 -0400
Date: Fri, 19 Oct 2012 12:54:21 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: joseph.salisbury@canonical.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        perex@perex.cz, tiwai@suse.de, david.henningsson@canonical.com,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ALSA: hda - add quirk for Thinkpad T430
Message-ID: <20121019195421.GC4787@elie.Belkin>
References: <cover.1350570761.git.joseph.salisbury@canonical.com>
 <fe78ea8daff3d5a41b6e1c78fb527894da6ad71e.1350570761.git.joseph.salisbury@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <fe78ea8daff3d5a41b6e1c78fb527894da6ad71e.1350570761.git.joseph.salisbury@canonical.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

joseph.salisbury@canonical.com wrote:

> This patch adds a quirk to enable headphone jack audio on T430 Thinkpads.
>
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Cc: <stable@vger.kernel.org>

Thanks --- this is a little better.

One more nit: it looks like this was reported, tested, and based on a
patch by Stefan Freyr.  Takashi, could you amend the message to
reflect that, or should the patch be resent?

Something like

-- >8 --
From: Stefán Freyr <stefan.freyr@gmail.com>
Subject: ALSA: hda - add dock support for Thinkpad T430

I have a Lenovo ThinkPad T430 and an UltraBase Series 3 docking
station.

Without this patch, if I plug my headphones into the jack on the
computer, everything works fine. The computer speakers mute and the
audio is played in the headphones. However, if I plug into the docking
station headphone jack the computer speakers are muted but there is no
audio in the headphones.

Addresses https://bugs.launchpad.net/bugs/1060372

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: stable@vger.kernel.org
