Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab2IMLvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:51:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57980 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab2IMLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:51:36 -0400
MIME-Version: 1.0
In-Reply-To: <s5h392m1728.wl%tiwai@suse.de>
References: <s5h392m1728.wl%tiwai@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Sep 2012 19:51:14 +0800
X-Google-Sender-Auth: ZoWugGHafZeD45BrxIdBa3lZk3o
Message-ID: <CA+55aFyo6do-dZiZMiwZkN1Ko+W58+4-zkbfJnpQR+ufw=+8ig@mail.gmail.com>
Subject: Re: [GIT PULL] sound fixes for 3.6-rc6
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 7:43 PM, Takashi Iwai <tiwai@suse.de> wrote:
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git for-linus

*PLEASE* don't do this.

You point to a branch, but then the pull request clearly implies there
is a tag with extra information in it.

And indeed, the actual thing I should pull is not at all "for-linus",
it seems to be your "tags/sound-3.6" tag.

I don't know if this is the old "git pull-request" breakage where it
stupidly "corrects" the remote branch when it verifies the branch
name, or whether it's some other scripting problem. I think current
git versions should not mess up the tag information, if that's the
cause, but please verify.

            Linus
