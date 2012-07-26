Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2GZVmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:42:49 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:17962 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2GZVmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:42:47 -0400
Date: Thu, 26 Jul 2012 23:42:46 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 0/5] staging: vt6656: small bug fixes and cleanups for
 hostapd.c
Message-ID: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

Here's a small series of patches that fixes some memory leaks and cleans 
up the code a bit for vt6656 hostapd.c - done on top of Linus' tree as of 
today.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

