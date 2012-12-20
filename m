Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2LTAwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:52:36 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:55420 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2LTAw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:52:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6vziasGs8cuatkniPVSJ4sst-EcPBEAaKeHDoKfqk4mbQ@mail.gmail.com>
References: <CACxGe6vziasGs8cuatkniPVSJ4sst-EcPBEAaKeHDoKfqk4mbQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Dec 2012 00:52:07 +0000
X-Google-Sender-Auth: ktDtIlry3OJCBI__A6WlEMa9-aw
Message-ID: <CACxGe6sb3exTgYeryOt4RBGPEBnRzWa=PpiHuKBf296bq1HS9w@mail.gmail.com>
Subject: Re: [GIT PULL] SPI bug fixes for v3.8 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        spi-devel-general@lists.sourceforge.net,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Forgot to cc: lkml]

On Thu, Dec 20, 2012 at 12:46 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> Hi Linus,
>
> And finally, here are the bug fixes I've queued up for SPI. Very
> little in the way of excitement other than a device driver feature
> that should have been in my first pull req, but I missed it. It should
> be low risk, but if it bothers you then I can respin without it.
>
> And now I'm off to bed.
>
> g.
>
> The following changes since commit 4939e27d46fee2609f2112f85f7f7cbd952075dc:
>
>   Merge tag 'devicetree-for-linus' of
> git://git.secretlab.ca/git/linux-2.6 (2012-12-14 15:37:46 -0800)
>
> are available in the git repository at:
>
>
>   git://git.secretlab.ca/git/linux-2.6 tags/spi-for-linus
>
> for you to fetch changes up to d3601e56cf64a3f2df6f6380cccb3644274406e2:
>
>   spi/sh-hspi: fix return value check in hspi_probe(). (2012-12-19
> 15:11:41 +0000)
>
> ----------------------------------------------------------------
> SPI device driver bug fixes branch for the v3.8 merge window. Most of
> this is bug fixes to the core code and the sh-hspi and s3c64xx device
> drivers.
>
> There is also a patch here to add DT support to the Atmel driver. This
> one should have been in the first round, but I missed it. It's a low
> risk change contained within a single driver and the Atmel maintainer
> has requested it.
>
> ----------------------------------------------------------------
> Allen Martin (1):
>       spi: fix tegra SPI binding examples
>
> Cyril Roelandt (1):
>       spi/sh-hspi: fix return value check in hspi_probe().
>
> David Daney (1):
>       of/spi: Fix SPI module loading by using proper "spi:" modalias prefixes.
>
> Jean-Christophe PLAGNIOL-VILLARD (1):
>       spi/atmel: add DT support
>
> Kyoungil Kim (2):
>       spi: Keep chipselect assertion during one message
>       spi: Change FIFO flush operation and spi channel off
>
>  .../bindings/spi/nvidia,tegra20-sflash.txt         |    2 +-
>  .../bindings/spi/nvidia,tegra20-slink.txt          |    2 +-
>  .../devicetree/bindings/spi/spi_atmel.txt          |   26 ++++++++++++++++++++
>  drivers/spi/spi-atmel.c                            |   17 ++++++++++++-
>  drivers/spi/spi-s3c64xx.c                          |   10 +++-----
>  drivers/spi/spi-sh-hspi.c                          |    2 +-
>  drivers/spi/spi.c                                  |    5 +++-
>  7 files changed, 53 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi_atmel.txt
>
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.



--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
