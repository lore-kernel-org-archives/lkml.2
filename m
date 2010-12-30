Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0L3H7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 02:59:33 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:48186 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0L3H7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 02:59:32 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimc2U==zvuRU67Bohsb5uCNjD8fX-6s7EefY6EQ@mail.gmail.com>
References: <AANLkTimc2U==zvuRU67Bohsb5uCNjD8fX-6s7EefY6EQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 30 Dec 2010 00:59:11 -0700
X-Google-Sender-Auth: V0qNN6mqexGpXZnJ6VmPDcW-S6c
Message-ID: <AANLkTi=PrTZ7faC6VQmqVjKo0FP9h1SqPFW7tWcsm2V8@mail.gmail.com>
Subject: Re: [git pull] one more spi bugfix for 2.6.37
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, missed one.  Here's an updated pull req.

The following changes since commit 387c31c7e5c9805b0aef8833d1731a5fe7bdea14:

  Linux 2.6.37-rc8 (2010-12-28 17:05:48 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 merge-spi

Gregory CLEMENT (1):
      spi/omap2_mcspi.c: Force CS to be in inactive state after
off-mode transition

Jate Sujjavanich (1):
      spi/m68knommu: Coldfire QSPI platform support

 drivers/spi/coldfire_qspi.c |    2 +-
 drivers/spi/omap2_mcspi.c   |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletions(-)


On Wed, Dec 29, 2010 at 6:45 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Hi Linus,
>
> Here is one more spi bug fix for .37
>
> The following changes since commit 387c31c7e5c9805b0aef8833d1731a5fe7bdea14:
>
>  Linux 2.6.37-rc8 (2010-12-28 17:05:48 -0800)
>
> are available in the git repository at:
>  git://git.secretlab.ca/git/linux-2.6 merge-spi
>
> Gregory CLEMENT (1):
>      spi/omap2_mcspi.c: Force CS to be in inactive state after
> off-mode transition
>
>  drivers/spi/omap2_mcspi.c |   39 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
