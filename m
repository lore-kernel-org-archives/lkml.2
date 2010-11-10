Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0KJNjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:39:13 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:54722 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755768Ab0KJNjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:39:12 -0500
Date: Wed, 10 Nov 2010 14:36:57 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-pcmcia@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC] PCMCIA bugfixes
Message-ID: <20101110133657.GA22986@comet.dominikbrodowski.net>
Mail-Followup-To: linux-pcmcia@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

in order to address a few -- mostly minor -- issues, I intend to push these
changes shortly. They're available at

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

As usual, I'm interested in your input to this patch series. The individual
patches will be sent out (at least) to the PCMCIA list in a few moments.

Best,
        Dominik

Andres Salomon (1):
      pcmcia: fix warning in synclink driver

Joe Perches (1):
      drivers/pcmcia/soc_common.c: Use printf extension %pV

Komuro (1):
      pd6729: Coding Style fixes

Nicolas Kaiser (1):
      pcmcia/cm4000: fix error code

Uwe Kleine-König (1):
      pcmcia/sa1100: don't put machine specific init functions in .init.text

 drivers/char/pcmcia/cm4000_cs.c   |    3 ++-
 drivers/char/pcmcia/synclink_cs.c |    1 +
 drivers/pcmcia/pd6729.c           |    8 ++++----
 drivers/pcmcia/pd6729.h           |    2 +-
 drivers/pcmcia/pxa2xx_sharpsl.c   |    2 +-
 drivers/pcmcia/sa1100_assabet.c   |    2 +-
 drivers/pcmcia/sa1100_cerf.c      |    2 +-
 drivers/pcmcia/sa1100_generic.c   |    2 +-
 drivers/pcmcia/sa1100_h3600.c     |    2 +-
 drivers/pcmcia/sa1100_shannon.c   |    2 +-
 drivers/pcmcia/sa1100_simpad.c    |    2 +-
 drivers/pcmcia/soc_common.c       |    9 +++++++--
 12 files changed, 22 insertions(+), 15 deletions(-)
