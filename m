Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab2AFIKU (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 6 Jan 2012 03:10:20 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:40099 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab2AFIKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:10:18 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Fri, 06 Jan 2012 12:10:16 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f06ac689d0a68.52782662@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >I have some unpleasant news: it looks like it takes slightly longer with
 >the 
 >fix, but the crash still managed to occur with 3.2 and I lack ESP to check 
 > for warnings immediately before that. I thought that 8 hours is enough 
 > testing, heh. It simply took 9 and a half under nigh-ideal conditions 
 > (stable signal from fixed AP with notebook also steadily in one place).

By the way, what could trigger these crashes in "network event sense"? If this 
can be reproduced with Ad-Hoc (something like ""Ad-Hoc peer changes ESSID then 
changes it back"), I could easily do some stress-testing with a second Linux-
running notebook.


