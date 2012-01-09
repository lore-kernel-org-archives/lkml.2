Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2AIHkT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 9 Jan 2012 02:40:19 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:44823 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab2AIHkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:40:17 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Mon, 09 Jan 2012 11:40:14 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f0a99de7f4ef4.35302262@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >> So, I am building 3.2 with two patches: over/under-flow catcher (pity
 >that
 >> it seems to be on a multiple-times-per-second codepath and just leaving
 >the
 > > checks there for everyone is suboptimal) and allegedely proper fix. Both
 > > applied OK with a small offset.
 > 
 > as per our assumption, we should not see those over/underflow errors,
 > with the patch
 > above mentioned. please let us know if you hit upon this warnings,
 > even after the proper fix.

In my experience (and as I understand the situation) if garbage is writen to 
the "chan", it is caught by the check and device is dead-until-reboot anyway. 
On 3.0, even without checks device was dead-until-reboot, but no crash 
happened. All these checks do is converting "panic" to "WiFi broken" for 3.2.


