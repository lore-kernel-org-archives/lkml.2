Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2EEMJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 08:09:52 -0400
Received: from antcom.de ([188.40.178.216]:48307 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab2EEMJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 08:09:50 -0400
Message-ID: <4FA5188A.1090401@antcom.de>
Date: Sat, 05 May 2012 14:09:46 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com, axel.lin@gmail.com, riyer@nvidia.com,
        michael.hennerich@analog.com, grant.likely@secretlab.ca,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Subject: [GIT PULL] input: keyboard: Add keys driver for the LPC32xx SoC
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the pull request for the LPC32xx keys driver, built on top of
git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git - branch "next"

Thanks in advance,

Roland


The following changes since commit 2872a9b521ac936c7a8525a8c2bdfb9b4ccf5cfc:

  Input: evdev - properly handle read/write with count 0 (2012-05-02 00:23:58 -0700)

are available in the git repository at:

  git://git.antcom.de/linux-2.6.git lpc32xx-keys

for you to fetch changes up to 0c98c603ef48859d887f6fee1d5b18481219d6ea:

  input: keyboard: Add keys driver for the LPC32xx SoC (2012-05-05 13:53:16 +0200)

----------------------------------------------------------------
Roland Stigge (1):
      input: keyboard: Add keys driver for the LPC32xx SoC

 .../devicetree/bindings/input/lpc32xx-key.txt      |   28 ++
 drivers/input/keyboard/Kconfig                     |   10 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/lpc32xx-keys.c              |  382 ++++++++++++++++++++
 4 files changed, 421 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/lpc32xx-key.txt
 create mode 100644 drivers/input/keyboard/lpc32xx-keys.c
