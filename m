Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1JYMMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:12:54 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59120 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab1JYMMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZi=Vh-BfT9w_JVtL+wUPNtO41HqffD2hxoyQyT02iVcw@mail.gmail.com>
References: <CACRpkdZi=Vh-BfT9w_JVtL+wUPNtO41HqffD2hxoyQyT02iVcw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 14:11:33 +0200
X-Google-Sender-Auth: iNVXMDU-BoBrzZnTwQokDTxNheA
Message-ID: <CA+55aFyt3GYRpbxZo4eyBj9BhhVSG2TwbtOC3XBvQBe1HbwdGQ@mail.gmail.com>
Subject: Re: [GIT PULL] pinctrl subsystem creation
To: Linus Walleij <linus.walleij@linaro.org>
Cc: jesper.nilsson@axis.com, Stephen Warren <swarren@nvidia.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rongjun Ying <rongjun.ying@csr.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:11 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
>
> this is a new subsystem in a new git so given all the current
> GnuPG signing and hoopla the probability of this being rejected
> for one or another reason tends to one. But anyway, here goes:

Hmm. No problem. At least it's not some open git repo, and yes, I can
check your gpg key - although whether it's actually *yours* I don't
know, because I don't know the people who signed it ;)

But anyway, looks good.

Except I wonder why you even made that CONFIG_PINCTRL user-visible?
Any driver that uses the interface had better have a "select PINCTRL"
in it, so actually asking the user whether they want that subsystem
seems to be just annoying and pointless, no?

So I suspect it should just be made a "def_bool n"?

And I hope all these new lines will result in more deleted lines later...

                    Linus
