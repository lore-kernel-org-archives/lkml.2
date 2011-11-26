Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1KZSR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 13:17:27 -0500
Received: from gherkin.frus.com ([192.158.254.49]:49129 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab1KZSR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 13:17:26 -0500
Date: Sat, 26 Nov 2011 12:17:24 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 3.2-rcX regression: boot failure on AMD K6-III/450
Message-ID: <20111126181724.GA1993@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verified for 3.2-rc[1-3].  Subject system using LILO as bootloader.
The following messages appear on the console:

Loading linux-dev.
BIOS data check successful
Probing EDD (edd=off to disable)... ok
<blank line>
Decompressing Linux... Parsing ELF... done.
Booting the kernel.
<hang here -- no further output>

The console output is normal and expected up to the point of the hang.
Versions 3.1 and prior work fine.  I had earlier thought the floppy
regression Pavel reported applied to my case (and it may), but I don't
seem to be getting that far in the boot process.

--Bob
