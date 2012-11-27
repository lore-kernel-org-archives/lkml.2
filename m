Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab2K0Isg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:48:36 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:59730
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758473Ab2K0Ise (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:48:34 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2012 03:48:34 EST
From: Tim Sander <tim01@iss.tu-darmstadt.de>
Organization: Sander & Lighting
To: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-rt-users@vger.kernel.org
Subject: am33xx beaglebone mainline status?
Date: Tue, 27 Nov 2012 09:41:51 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc4-00136-gaffd9a8; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211270941.52055.tim01@iss.tu-darmstadt.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have been trying to get the 3.7-rc6 kernel to compile for a beaglebone board 
with device tree but it seems there are still bits missing. Especially it 
seems as if the sd card reader and network is not working properly?

I would also like to combine the barebone with a recent 3.6 preempt rt 
patchset. Any ideas where to start?

Besides is there any recent git repository where the beaglebone works? The 
only thing which seems to run is the 3.2 kernel "repository" also found in oe?

Best regards
Tim
