Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2LCRmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:42:15 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51321 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab2LCRmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:42:12 -0500
MIME-Version: 1.0
In-Reply-To: <20121203173951.GA25384@fancy-poultry.org>
References: <20121203173951.GA25384@fancy-poultry.org>
Date: Mon, 3 Dec 2012 12:42:11 -0500
Message-ID: <CAHdPZaP6HvM=UqkAjyC8MFMv9ZFTyxjx-CsMQ+8QZaxPCaW1Hw@mail.gmail.com>
Subject: Re: i915 freakout with latest 3.7 git
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Heinz Diehl <htd@fancy-poultry.org>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more CC's

On Mon, Dec 3, 2012 at 12:39 PM, Heinz Diehl <htd@fancy-poultry.org> wrote:
> Hi,
>
> with latest linus-3.7 git from today, after some time, my machine gets
> more and more unresponsible, fanspeed increases, and that's what I see in the logs:
>
> Dec  3 18:08:10 wildsau kernel: [35092.535757] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> Dec  3 18:08:10 wildsau kernel: [35092.535768] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
> Dec  3 18:08:12 wildsau kernel: [35094.050918] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> Dec  3 18:08:12 wildsau kernel: [35094.051081] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
> Dec  3 18:08:12 wildsau kernel: [35094.051086] [drm:i915_reset] *ERROR* Failed to reset chip.
>
> I have never seen that before, up to 3.6.7.
>
> Don't know what information would be important for you, but will
> provide anything you'll ask me to.
>
> Thanks,
> Heinz.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
