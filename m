Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab1LHGL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 01:11:28 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:57341 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1LHGL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 01:11:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEACtU4E5bdWOb/2dsb2JhbABDq16CTyI9FhgDAgECASckDQgCiAUGlyifMIs0BJRrkiQ
X-IronPort-AV: E=Sophos;i="4.71,318,1320620400"; 
   d="scan'208";a="924366233"
Message-ID: <4EE05503.1040200@igalia.com>
Date: Thu, 08 Dec 2011 07:11:15 +0100
From: Carlos Alberto Lopez Perez <clopez@igalia.com>
Organization: Igalia S.L.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel paging request when attaching USB device
 (Smart Board)
X-Enigmail-Version: 1.1.2
OpenPGP: id=6B95F882;
	url=http://key.neutrino.es
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


Each time I attach a smarttech smart board USB device to the laptop I get the following kernel failures:


http://people.igalia.com/clopez/kern.log-oops-smartboard-2.6.39.1-7-custom-686


This is the .config for the kernel I am running:
http://people.igalia.com/clopez/config-2.6.39.1-7-custom-686


After a long search I found a guy with the same problem but with a 2.6.32 kernel:

http://exchange-forum.smarttech.com/forums/t/7866.aspx (select USA) 


Anybody can give me some idea of what is happening and could this be solved? What is triggering this error? After this errors the system often gets stuck and is needed to hard reboot it.


Is there any commit related to this since 2.6.39 that could fix this?


Thanks!
