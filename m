Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2AIHF2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 9 Jan 2012 02:05:28 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:42945 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab2AIHF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:05:26 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Mon, 09 Jan 2012 11:05:23 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f0a91b3e9c7f4.40986810@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > Around 23 hours have elapsed.
 > >
 >> WiFi seems to be working 100% of time. It is always at least lightly
 >loaded.
 
45h - all OK.

 > great and thanks a lot for testing!

Doesn't really require _doing_ anything except building patched kernels. And 
it is in my best interest to test the driver for the WiFi card I use...

 > rather than removing the suspicious code
 > this is properly fixed by us with this patch.
 > http://marc.info/?l=linux-wireless&m=132595161516806&w=2

Ah, I saw the message and wondered whether it is the fix I needed and what 
patches should I apply.

So, I am building 3.2 with two patches: over/under-flow catcher (pity that 
it seems to be on a multiple-times-per-second codepath and just leaving the 
checks there for everyone is suboptimal) and allegedely proper fix. Both 
applied OK with a small offset.



