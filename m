Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0LHRWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:22:34 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:33949 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0LHRWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:22:33 -0500
Date: Wed, 8 Dec 2010 18:22:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.37
Message-ID: <20101208182222.247ea405@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 drivers/hwmon/adm1026.c |   20 +++++++-------
 drivers/hwmon/it87.c    |   61 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 55 insertions(+), 26 deletions(-)

---------------

Gabriele Gorla (2):
      hwmon: (adm1026) Fix setting fan_div
      hwmon: (adm1026) Allow 1 as a valid divider value

Jean Delvare (1):
      hwmon: (it87) Fix manual fan speed control on IT8721F

Thanks,
-- 
Jean Delvare
