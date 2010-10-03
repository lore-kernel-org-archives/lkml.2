Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab0JCDoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 23:44:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49279 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0JCDoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 23:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimgKWoFt8Kd3DCG20Mpkib54ePPiiGbabVvrYuU@mail.gmail.com>
References: <AANLkTimgKWoFt8Kd3DCG20Mpkib54ePPiiGbabVvrYuU@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 2 Oct 2010 21:43:50 -0600
X-Google-Sender-Auth: vQzKraPTq067nd4yw08RddKKqk0
Message-ID: <AANLkTi=GjpvhexkGdwJmigX0yOE6at-vdEq+OR_HG9kG@mail.gmail.com>
Subject: Re: [git pull] SPI bug fixes for 2.6.36
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Cc: Roel Kluin <roel.kluin@gmail.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Sinan Akman <sinan@writeme.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, missed one.  Here is an updated pull req:

The following changes since commit c6ea21e35bf3691cad59647c771e6606067f627d:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge-spi

Roel Kluin (1):
      spi: spi-gpio.c tests SPI_MASTER_NO_RX bit twice, but not SPI_MASTER_NO_TX

Sinan Akman (1):
      of/spi: Fix OF-style driver binding of spi devices

christophe leroy (1):
      spi/mpc8xxx: fix buffer overrun on large transfers

 drivers/spi/spi.c         |    5 +++++
 drivers/spi/spi_gpio.c    |    2 +-
 drivers/spi/spi_mpc8xxx.c |   10 ++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)



On Sat, Oct 2, 2010 at 9:26 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Hi Linus,
>
> Some spi bug fixes for 2.6.36
>
> The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:
>  Linus Torvalds (1):
>        Linux 2.6.36-rc6
>
> are available in the git repository at:
>
>  git://git.secretlab.ca/git/linux-2.6 merge-spi
>
> Roel Kluin (1):
>      spi: spi-gpio.c tests SPI_MASTER_NO_RX bit twice, but not SPI_MASTER_NO_TX
>
> christophe leroy (1):
>      spi/mpc8xxx: fix buffer overrun on large transfers
>
>  drivers/spi/spi_gpio.c    |    2 +-
>  drivers/spi/spi_mpc8xxx.c |   10 ++++++++--
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
