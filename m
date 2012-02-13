Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2BMLRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 06:17:31 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:41455 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2BMLRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 06:17:30 -0500
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Deadlock?
Date: Mon, 13 Feb 2012 12:17:28 +0100
Message-ID: <3125411.WeeEOF8PnR@f209>
User-Agent: KMail/4.8.0 (Linux/3.2.4-gentoo; KDE/4.8.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:brQEop6OZx4DwTsuONzS/ftzdX/mpeJe8G+sxtnM7oc
 POOScjD7I+LuBdLMkFPfCxP9QvdYNhr07LM5NQIaWV2MihMMyW
 hiyTS3l8GbPe9YKVaZQrsa8kHHG0HYArHi6mbC/Q7QZVKqtW3E
 ibsU8kEu4CKS42iojJ2fLm+sc3thKWDbG3WldJGtyKRLCB6HAq
 lHdRfOtfFTK/4fYXx18+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I noted some kind of deadlock, where I was not able to write to the raid6, 
while writing to each disk would still work.
This caused many processes to "wait" in d-state, thus making it impossible to 
unmount, cleanly reboot, sync, ...

So I enabled the detection of hung tasks and this deplock option.
After running a 3.2.2 for about 5 days:
http://pastebin.com/gy1kaYmS

I dont know if its a bug or nothing. Or if it has anything to do with my 
problem as there was no hungtask detected and the raid still seems to work.

Can anybody enlight me?! ;)

Markus
