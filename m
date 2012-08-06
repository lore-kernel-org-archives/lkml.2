Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2HFCRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:17:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47262 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab2HFCRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAGh4K3+8etOJvS6PCuJJjtj978F5rtpck_Y34Owqx+yhbg3LhQ@mail.gmail.com>
References: <CAGh4K3+8etOJvS6PCuJJjtj978F5rtpck_Y34Owqx+yhbg3LhQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 6 Aug 2012 12:16:44 +1000
Message-ID: <CAGRGNgUNAwPRfH21ifBWVY6w5YRzW9OFz0p5idaX+YZ2eF4QmQ@mail.gmail.com>
Subject: Re: [PATCH]: Mac80211
To: Christopher Sacchi <chris.sacchi@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On Mon, Aug 6, 2012 at 12:02 PM, Christopher Sacchi
<chris.sacchi@gmail.com> wrote:
> The source file needed a change  that was told in the description to
> know that the #include needed to be fixed, and the function changed
> another value to 0 (yes) in the description (that said FIXME.)

This still doesn't explain everything.

I'm guessing that the changes you're making fix some bug you've seen.

Your patch description, which should be in the *same* email as the
correctly formatted patch itself needs to tell us what bug this fixes,
including any error messages that appear, and do so clearly and
sensibly so that the maintainer (Johannes) can quickly and easily
evaluate whether this patch is worth accepting.

You also need to format it correctly so that if he decides to accept
it, he can import it directly using git.

To do that, you need to send a *single* email that contains the
description and the patch, following the rules here:

https://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=Documentation/SubmittingPatches;h=c379a2a6949f1c1cac04fb6f185c633512f37061;hb=HEAD

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
