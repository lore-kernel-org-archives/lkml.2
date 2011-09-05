Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1IEOGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:06:03 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:59988 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1IEOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:05:59 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E64D936.9030904@cam.ac.uk>
Date: Mon, 05 Sep 2011 15:14:14 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Current state of regmap.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

As my previous email said I've been messing around with regmap today.
I've run into a couple of bugs and was wondering if I'm running
behind the current version.  I've pulled what is up on kernel.org
for linux-next at the moment.

As I'm emailing anyway.  Everywhere other than regmap-debugfs max_register
is treated as the max valid.  In there we have a loop that is
for (i = 0; i < map->max_register; i++) so that treats it as one
larger than the max valid register index.

Thanks,

Jonathan.

p.s. Nice work by the way.
