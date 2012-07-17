Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2GQW6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:58:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60240 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2GQW6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:58:16 -0400
Message-ID: <5005EE01.6000802@gmail.com>
Date: Wed, 18 Jul 2012 08:58:09 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Prylowski <prylowski@metasoft.pl>
Subject: [GIT PULL] ep93xx-devel for 3.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, Olof,

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://github.com/RyanMallon/linux-ep93xx.git tags/ep93xx-devel-for-3.6

for you to fetch changes up to 762be29733d5b02b4359691f64c0cc968cd23c93:

  ep93xx: Add IDE support to edb93xx boards (2012-06-04 14:52:17 +1000)

----------------------------------------------------------------
Rafal Prylowski (2):
      ep93xx: IDE driver platform support code
      ep93xx: Add IDE support to edb93xx boards

 arch/arm/mach-ep93xx/core.c                  |   96 ++++++++++++++++++++++++++
 arch/arm/mach-ep93xx/edb93xx.c               |   24 +++++++
 arch/arm/mach-ep93xx/include/mach/platform.h |    3 +
 arch/arm/mach-ep93xx/soc.h                   |    1 +
 4 files changed, 124 insertions(+)

