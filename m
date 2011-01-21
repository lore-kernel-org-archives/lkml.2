Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1AUCcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 21:32:46 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:42764 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1AUCcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 21:32:45 -0500
X-Greylist: delayed 2235 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2011 21:32:45 EST
Date: Fri, 21 Jan 2011 10:55:29 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: regression 2.6.37 -> 2.6.38-rc1: after suspend backlight cannot be
	adjusted
Message-ID: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please Cc)

going to 2.6.38-rc1 I see the following regression: After reboot I
can easily adjust the backlight with the keys on my keyboard, but 
after a suspend-to-ram this does not work anymore.

This is a Sony laptop, and backlight is controlled by the video
acpi driver AFAIR.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
AASLEAGH (n.)
A liqueur made only for drinking at the end of a revoltingly long
bottle party when all the drinkable drink has been drunk.
			--- Douglas Adams, The Meaning of Liff
