Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2BIAwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 19:52:37 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51478 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671Ab2BIAwg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 19:52:36 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzbR2-_uAz-Rfc_OuK3NAj+PKyjKhDCMoHAwE7+jgmxQA@mail.gmail.com>
References: <CACxGe6uf6BpnHUFF7Svx_-C+ZGFop3T=TGGRi8kFQCgH56E4yA@mail.gmail.com>
 <CA+55aFzbR2-_uAz-Rfc_OuK3NAj+PKyjKhDCMoHAwE7+jgmxQA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 8 Feb 2012 16:52:16 -0800
X-Google-Sender-Auth: 6eRVq5GAUZAoJIj963K0WtfL4Cw
Message-ID: <CACxGe6sRHg3txoxcBLDUVLFfjXOCYAGOk+Cou=a7teJR0qtC1w@mail.gmail.com>
Subject: Re: [git pull] SPI changes for v3.3-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 3:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Feb 5, 2012 at 10:28 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> A couple of minor SPI fixes.  Description in signed tag.  Please pull.
>
> No can do. I get "already up-to-date".
>
> It looks like the 'for-linus" tag is your *previous* one - you either
> forgot to push, or you pushed without forcing an over-write and didn't
> notice that git told you that it's not going to update a
> non-fast-forward write or something.
>
> Hmm?

It looks like the branch got pushed, but not the tag.  Fixed now.
Below is the updated pull request.

> Btw, exactly because problems sometimes happen, I do want to see the
> description written out in the email too. The whole reason I want to
> see diffstats and shortlogs is exactly because "it is correct in the
> git tree" is not useful - the email should be a *confirmation* that
> what I pulled from the git tree was really what you meant.

Okay.  Will do.

g.

---

SPI bug fixes for v3.3-rc2

Minor SPI device driver changes.  A rename of the pch_spi_pcidev symbol
that merely eliminates a modpost warning, and a Kconfig change to allow
the Samsung spi driver to build on EXYNOS.

The following changes since commit e862f2e4693f287669e84971c778bf071bd0526b:

  Merge tag 'sound-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2012-02-08
14:56:39 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi-for-linus

Danny Kukawka (1):
      spi-topcliff-pch: rename pch_spi_pcidev to pch_spi_pcidev_driver

Sylwester Nawrocki (1):
      spi: Add spi-s3c64xx driver dependency on ARCH_EXYNOS4

 drivers/spi/Kconfig            |    2 +-
 drivers/spi/spi-topcliff-pch.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)
