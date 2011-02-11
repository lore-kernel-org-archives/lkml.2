Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1BKMMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:12:32 -0500
Received: from ni.piap.pl ([195.187.100.4]:32768 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab1BKMMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:12:31 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Feb 2011 07:12:31 EST
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Greg Kroah-Hartman <greg@kroah.com>, Ben Collins <bcollins@bluecherry.net>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 11 Feb 2011 13:05:44 +0100
MIME-Version: 1.0
Message-ID: <m3sjvurd2f.fsf@t19.piap.pl>
Content-Type: text/plain; charset=us-ascii
Subject: [STAGING] Solo6x10 driver
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110211 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently working on the SOLO6x10 driver (using SOLO 6010 and 6110
cards), with i686 and MIPS (big-endian) based systems. I'm attaching a
few patches.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
