Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1CWWPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:15:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59904 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1CWWPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AVfhheECEJIpmPtSSPYC9LUEudzftrQHnsGamEm8jzpfc+KDe3+NpLZ+Lh3ljt2kcI
         Mm2Ujty0jEJugX+LUXt3K+FUIitNQDBX6HPc0ZwNPvXl6X1rWxLq8/vdOIQrXfvC2XGa
         IrxurG5eC1sgjz8pYuD9mMhcrF78okfOlA4Ko=
MIME-Version: 1.0
In-Reply-To: <AANLkTimHzPn2Xe1RVRQKjwdynDvc3iL2=8kJ1p8kRZQ4@mail.gmail.com>
References: <1300768985-902-1-git-send-email-gerg@snapgear.com>
	<AANLkTimHzPn2Xe1RVRQKjwdynDvc3iL2=8kJ1p8kRZQ4@mail.gmail.com>
Date: Wed, 23 Mar 2011 23:14:58 +0100
X-Google-Sender-Auth: LOnnwV8qN5kDm4n0ofET07F9EyA
Message-ID: <AANLkTi=ohXGdwfAtWmDJKCq+cJtFqJdTCmPCxFOg6dY6@mail.gmail.com>
Subject: Re: [PATCH 0/1] m68k: merge m68k and m68knommu arch directories
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: gerg@snapgear.com
Cc: linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 23:07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Mar 22, 2011 at 05:43,  <gerg@snapgear.com> wrote:
>> The following patch merges the m68k and m68knommu arch directories.
>> This patch has been trimmed for review purposes - the automated file
>> moving and mergeing carried out by the script contained in this email
>> has been removed. Only the manually required changes after running the
>> script are shown as the patch. (So to end up with the final required
>> change you need to run this script then apply the patch).
>>
>> This change is available as the only commit on the m68knommu git tree,
>> for-linux branch:
>>
>> The following changes since commit a952baa034ae7c2e4a66932005cbc7ebbccfe28d:
>>  Linus Torvalds (1):
>>        Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input
>>
>> are available in the git repository at:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus
>>
>> Greg Ungerer (1):
>>      m68k: merge m68k and m68knommu arch directories
>>
>>
>> It is also on the for-next branch in that tree, so will get some testing
>> in the next tree for the next few days.
>
> defconfig is now a nommu-config, and it fails?

BTW, haven't tried it myself yet. I'm busy bisecting an issue with
initrds, which
got introduced between 2.6.37 and 2.6.38.

Init fails with "init: cannot open inittab", followed by
"Kernel panic - not syncing: Attempted to kill init!".

As I can't get ramdisks to work on ARAnyM, I need to use real hardware, which
suffers a lot from long reboot/copy kernel/test cycles...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
