Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2BFXe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:34:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47569 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2BFXe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:34:57 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6uf6BpnHUFF7Svx_-C+ZGFop3T=TGGRi8kFQCgH56E4yA@mail.gmail.com>
References: <CACxGe6uf6BpnHUFF7Svx_-C+ZGFop3T=TGGRi8kFQCgH56E4yA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Feb 2012 15:34:37 -0800
X-Google-Sender-Auth: rljTvD96bqvMELh5nT7FdFXfmS4
Message-ID: <CA+55aFzbR2-_uAz-Rfc_OuK3NAj+PKyjKhDCMoHAwE7+jgmxQA@mail.gmail.com>
Subject: Re: [git pull] SPI changes for v3.3-rc2
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 10:28 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
> A couple of minor SPI fixes.  Description in signed tag.  Please pull.

No can do. I get "already up-to-date".

It looks like the 'for-linus" tag is your *previous* one - you either
forgot to push, or you pushed without forcing an over-write and didn't
notice that git told you that it's not going to update a
non-fast-forward write or something.

Hmm?

Btw, exactly because problems sometimes happen, I do want to see the
description written out in the email too. The whole reason I want to
see diffstats and shortlogs is exactly because "it is correct in the
git tree" is not useful - the email should be a *confirmation* that
what I pulled from the git tree was really what you meant.

So saying "it's all there in the tag" is undermining the use of the
email as verification of the git tree update having gone correctly.

                      Linus
