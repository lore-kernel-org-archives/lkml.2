Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3ADKYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 05:24:51 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:47158 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab3ADKYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 05:24:47 -0500
Message-ID: <50E6AD77.1000707@free.fr>
Date: Fri, 04 Jan 2013 11:22:47 +0100
From: dAgeCKo <dagecko@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Fwd: Linux - AMD SB950 USB Regression
References: <50C9FCD6.6050809@free.fr>
In-Reply-To: <50C9FCD6.6050809@free.fr>
X-Forwarded-Message-Id: <50C9FCD6.6050809@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Some months ago I noticed that my USB controler (and also my network
controler) does not work anymore on newer kernels from my debian wheezy
distribution.

I then reported a bug for the former one here:

https://bugzilla.kernel.org/show_bug.cgi?id=47791

With some helps and time, I could locate the source of the regression,
that is an old commit from the year 2010 you seem to commit. Git
besection identified the commit as:

git bisect bad 5c80cc78de46aef6cd5e714208da05c3f7f548f8

Someone from the usb kernel mailing list (Alan Stern) then asked me to
write an email to you, in my hope the bug to be solved.

Some informations were said on the bug tracker, but if you need any
other information that could help you in any manner, please let me know.

Please note that the regression only involves USB2 ports of the
mainboard, not the USB3 ports.

Regards.

---
Jean-Dominique Frattini
