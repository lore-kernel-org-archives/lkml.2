Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab2AKRUy (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 11 Jan 2012 12:20:54 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:53215 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2AKRUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:20:52 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Wed, 11 Jan 2012 21:20:49 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f0dc4f1ec60a3.38796665@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> does roaming seems to trigger this issue consistently ?
> . please provide the logs
> sudo modprobe -v ath9k debug=0xffffffff
> http://linuxwireless.org/en/users/Drivers/ath9k/debug

As I need to rebuild for CONFIG_ATH_DEBUG: should I check the allegedely 
proper fix or wide-angle code removal first?


