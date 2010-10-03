Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab0JCD1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 23:27:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53445 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0JCD1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 23:27:21 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 2 Oct 2010 21:26:58 -0600
X-Google-Sender-Auth: 3xuS7CdeP3cIqPIbbi7Ga8AxOXU
Message-ID: <AANLkTimgKWoFt8Kd3DCG20Mpkib54ePPiiGbabVvrYuU@mail.gmail.com>
Subject: [git pull] SPI bug fixes for 2.6.36
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Cc: Roel Kluin <roel.kluin@gmail.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some spi bug fixes for 2.6.36

The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:
  Linus Torvalds (1):
        Linux 2.6.36-rc6

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge-spi

Roel Kluin (1):
      spi: spi-gpio.c tests SPI_MASTER_NO_RX bit twice, but not SPI_MASTER_NO_TX

christophe leroy (1):
      spi/mpc8xxx: fix buffer overrun on large transfers

 drivers/spi/spi_gpio.c    |    2 +-
 drivers/spi/spi_mpc8xxx.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
