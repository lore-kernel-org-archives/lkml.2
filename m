Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab2AHHTn (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 8 Jan 2012 02:19:43 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:52069 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab2AHHTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 02:19:41 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Sun, 08 Jan 2012 11:19:38 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f09438ac7d220.32208778@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  > *does the other patch which remove some suspicious looking code, to
 >  > see if it improves the situation and avoids the warnings itself.
 > 
 >I have built and loaded the kernel with this patch. I even have netconsole
 >
 > apparently working. But ten hours have not elapsed yet. So far so good.
 > 
 > If it works till the 10th, I will test it with roaming, too. 

Around 23 hours have elapsed. 

WiFi seems to be working 100% of time. It is always at least lightly loaded.

Speedtests seems to gve slightly better upload results than I remember with 
2.6.* (and I have a good enough ISP for WiFi to be the weakest link), so it 
doesn't seem to be a performance regression, either.

As for roaming while connected - I will try not to forget to test it on the 
10th.


