Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1BIDx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:53:27 -0500
Received: from bosmailout06.eigbox.net ([66.96.187.6]:58073 "EHLO
	bosmailout06.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab1BIDx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:53:26 -0500
X-Greylist: delayed 2373 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Feb 2011 22:53:26 EST
X-EN-OrigOutIP: 10.20.18.11
X-EN-IMPSID: 5fDr1g0090EKspE01fDr2b
Message-ID: <4D52080A.1090100@jaysonking.com>
Date: Tue, 08 Feb 2011 21:20:42 -0600
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Stable team <stable@kernel.org>
Subject: 2.6.27.58-rc1 build error Re: [PATCH 21/23] hvc_console: Fix race
 between hvc_close and hvc_remove
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 67.65.251.18
X-EN-OrigHost: adsl-67-65-251-18.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/hvc_console.c: In function 'hvc_open':
drivers/char/hvc_console.c:315: error: implicit declaration of function 
'tty_kref_get'
drivers/char/hvc_console.c:324: warning: assignment makes pointer from 
integer without a cast
drivers/char/hvc_console.c:341: error: implicit declaration of function 
'tty_kref_put'
drivers/char/hvc_console.c: In function 'hvc_poll':
drivers/char/hvc_console.c:558: warning: assignment makes pointer from 
integer without a cast
drivers/char/hvc_console.c: In function 'hvc_remove':
drivers/char/hvc_console.c:759: warning: assignment makes pointer from 
integer without a cast

I don't see a tty_kref_get or tty_kref_put on 2.6.27. Those functions 
first appeared in 2.6.28.

Jayson

