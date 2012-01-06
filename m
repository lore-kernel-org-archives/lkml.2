Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2AFMvo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 6 Jan 2012 07:51:44 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:55038 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2AFMvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:51:42 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Fri, 06 Jan 2012 16:51:39 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.178.216.22
Message-ID: <NEXT-4f06ee5c00c505.33406970@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >:(  i had put those warnings to prevent the crash itself and what's causing
 >it.
 > may be i had missed that pos can be < 0 in addition to (pos > 37).
 > i am just looking at those areas of code for some other issue. hope i
 > can a find a fix
 > for both of them

I am building kernel with pos<0 check added...

I hoped for some ad-hoc stress-test recommendation, but I guess this will have 
to wait. 


