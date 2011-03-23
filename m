Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1CWWHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:07:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1CWWHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jkKvcoSs1Ptdbiv/3HP7Ku3o6ImPdmlb/wL1HIms41+1UlWaHoVkQUKuFD5zNDmQ2Y
         rY4ex3afElmyS7wZWCgxU37ZpL/20DP8zcjgmNBYbeB/YLrJJ6gVnbfcZGkcYCJlKUmp
         MOnPQz5tXRVzwbhdjYZ/iafLUibv+3EcPBreE=
MIME-Version: 1.0
In-Reply-To: <1300768985-902-1-git-send-email-gerg@snapgear.com>
References: <1300768985-902-1-git-send-email-gerg@snapgear.com>
Date: Wed, 23 Mar 2011 23:07:48 +0100
X-Google-Sender-Auth: r98Vs0UjFfB2o3fdHoHCf4t7drg
Message-ID: <AANLkTimHzPn2Xe1RVRQKjwdynDvc3iL2=8kJ1p8kRZQ4@mail.gmail.com>
Subject: Re: [PATCH 0/1] m68k: merge m68k and m68knommu arch directories
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: gerg@snapgear.com
Cc: linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org,
        linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 05:43,  <gerg@snapgear.com> wrote:
> The following patch merges the m68k and m68knommu arch directories.
> This patch has been trimmed for review purposes - the automated file
> moving and mergeing carried out by the script contained in this email
> has been removed. Only the manually required changes after running the
> script are shown as the patch. (So to end up with the final required
> change you need to run this script then apply the patch).
>
> This change is available as the only commit on the m68knommu git tree,
> for-linux branch:
>
> The following changes since commit a952baa034ae7c2e4a66932005cbc7ebbccfe28d:
>  Linus Torvalds (1):
>        Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus
>
> Greg Ungerer (1):
>      m68k: merge m68k and m68knommu arch directories
>
>
> It is also on the for-next branch in that tree, so will get some testing
> in the next tree for the next few days.

defconfig is now a nommu-config, and it fails?

http://kisskb.ellerman.id.au/kisskb/buildresult/4012794/

arch/m68k/kernel/entry_no.S:47: Error: Unknown operator -- statement
`save_all' ignored
arch/m68k/kernel/entry_no.S:56: Error: Unknown operator -- statement
`save_all' ignored
arch/m68k/kernel/entry_no.S:92: Error: operands mismatch -- statement
`moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/kernel/entry_no.S:96: Error: operands mismatch -- statement
`moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/kernel/entry_no.S:100: Error: operands mismatch -- statement
`moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/kernel/entry_no.S:104: Error: operands mismatch -- statement
`moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/kernel/entry_no.S:108: Error: operands mismatch -- statement
`moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/kernel/entry_no.S:112: Error: operands mismatch -- statement
`moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/kernel/entry_no.S:116: Error: operands mismatch -- statement
`moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/kernel/entry_no.S:118: Error: operands mismatch -- statement
`moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/kernel/entry_no.S:122: Error: operands mismatch -- statement
`moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/kernel/entry_no.S:124: Error: operands mismatch -- statement
`moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/platform/coldfire/entry.S:65: Error: Unknown operator --
statement `save_all' ignored
arch/m68k/platform/coldfire/entry.S:92: Error: operands mismatch --
statement `moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/platform/coldfire/entry.S:94: Error: operands mismatch --
statement `moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/platform/coldfire/entry.S:100: Error: operands mismatch --
statement `moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/platform/coldfire/entry.S:104: Error: operands mismatch --
statement `moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/platform/coldfire/entry.S:144: Error: Unknown operator --
statement `restore_user' ignored
arch/m68k/platform/coldfire/entry.S:156: Error: operands mismatch --
statement `moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/platform/coldfire/entry.S:160: Error: operands mismatch --
statement `moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/platform/coldfire/entry.S:169: Error: Unknown operator --
statement `save_all' ignored
arch/m68k/platform/coldfire/entry.S:193: Error: Unknown operator --
statement `rdusp' ignored
arch/m68k/platform/coldfire/entry.S:196: Error: operands mismatch --
statement `moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/platform/coldfire/entry.S:199: Error: operands mismatch --
statement `moveml %sp@+,%a3-%a6/%d6-%d7' ignored
arch/m68k/platform/coldfire/entry.S:202: Error: Unknown operator --
statement `wrusp' ignored

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
