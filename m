Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab1APJTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 04:19:17 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:37558 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1APJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 04:19:11 -0500
Date: Sun, 16 Jan 2011 10:19:07 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: No MMC device recognition after suspend
Message-ID: <20110116091907.GB12488@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.osknowledge.org/~marc/pubkey.asc
X-Operating-System: Linux marc 2.6.37-ck1-dezzy
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I found out that the "17ef:1003 Lenovo Integrated Smart Card Reader" does no
longer detect an inserted SDHC card once the box (T510) has been suspended.
After reloading udev the device detects inserted cards as it did before. The
behaviour applies to 2.6.37, later versions not tested, as suspend/resume is
currently broken on the box.

There's no logging once the card is inserted and not detected, just mount
stating that /dev/mmcblk0p1 is not present.

Any hints are very appreciated.

Regards,
	Marc

-- 
Marc Koschewski
