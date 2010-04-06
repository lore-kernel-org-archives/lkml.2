Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab0DFPeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:34:20 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:62391 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0DFPeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=v5cmI+bemnJZXQ8UWN9bsBmmUEkadg5TfHdXUBW9V/zAMoHo3MYs+GcWfGo03fAwzc
         ZCe3NYMHrlfQGsfaihkFMzp23i3zUg5X2+CgcqUNERC+2TTYbRmn7PjewHp62TzifXNm
         b0aB+FJ1Ly1X+gj4LXIUuyBKyRT5zjUmSexOQ=
MIME-Version: 1.0
In-Reply-To: <20100406063051.GB1895@core.coreip.homeip.net>
References: <20100406063051.GB1895@core.coreip.homeip.net>
From: Cory Maccarrone <darkstar6262@gmail.com>
Date: Tue, 6 Apr 2010 08:33:50 -0700
Message-ID: <m2j6cb013311004060833k76a89ad4r4ee848ea8f5492d4@mail.gmail.com>
Subject: Re: [git pull] Input updates for 2.6.34-rc3
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 5, 2010 at 11:30 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Linus,
>
> Please pull from:
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
>        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
>
> to receive updates for the input subsystem.
>
> Changelog:
> ---------
>
> Chase Douglas (1):
>      Input: ALPS - add signature for HP Pavilion dm3 laptops
>
> Dmitry Torokhov (1):
>      Input: sparse-keymap - implement safer freeing of the keymap
>
> Dominik Brodowski (1):
>      Input: i8042 - spelling fix
>
> H Hartley Sweeten (1):
>      Input: matrix_keypad - allow platform to disable key autorepeat
>
> Henrik Rydberg (3):
>      Input: bcm5974 - retract efi-broken suspend_resume
>      Input: clarify the no-finger event in multitouch protocol
>      Input: update the status of the Multitouch X driver project
>
> Yong Wang (1):
>      Input: sparse-keymap - free the right keymap on error
>
>
> Diffstat:
> --------
>
>  Documentation/input/multi-touch-protocol.txt |   23 ++++++++---
>  drivers/input/input.c                        |    9 ++++-
>  drivers/input/keyboard/matrix_keypad.c       |    4 +-
>  drivers/input/mouse/alps.c                   |    1 +
>  drivers/input/mouse/bcm5974.c                |    1 -
>  drivers/input/serio/i8042.c                  |    2 +-
>  drivers/input/sparse-keymap.c                |   52 ++++++++++++++++---------
>  include/linux/input/matrix_keypad.h          |    2 +
>  8 files changed, 65 insertions(+), 29 deletions(-)
>
> --
> Dmitry
>

I'm still waiting on some review for my TSC2046 touchscreen driver.
Last time I inquired about it, I was told it would be reviewed, but
there has not been any movement at all on it, and it's been out for
review for several months now.  Do I need to do more work on it?  Is
there something else needed?

- Cory
