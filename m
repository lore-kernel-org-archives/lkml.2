Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2ELHRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 03:17:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2ELHRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 03:17:33 -0400
Message-ID: <4FAE0E88.2030703@suse.cz>
Date: Sat, 12 May 2012 09:17:28 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120426 Thunderbird/13.0
MIME-Version: 1.0
To: stable@kernel.org
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: 3.3.5 regression: resume doesn't switch to X
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since update to 3.3.5, my X doesn't show up after resume from
hibernation anymore. The only thing I see is "resuming..." on the
console. I can switch to any tty and login in text mode, but cannot
switch to X despite it is running. I have to restart whole session to
have X again.

Now I'm back to 3.3.4 and everything is OK.

Using radeon driver on:
01:00.0 VGA compatible controller [0300]: Advanced Micro Devices [AMD]
nee ATI RV515 [Radeon Mobility X1450] [1002:7186]

regards,
-- 
js
suse labs

