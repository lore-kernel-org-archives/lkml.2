Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332Ab2AFOqL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 6 Jan 2012 09:46:11 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:44043 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734Ab2AFOqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:46:09 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Fri, 06 Jan 2012 18:46:07 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.178.216.22
Message-ID: <NEXT-4f07092f473990.86346967@nextmail.ru>
Mime-Version: 1.0
Content-type: text/plain;
	 charset="koi8-r"
Content-transfer-encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > š> can a find a fix
 > > š> for both of them
 > >
 > > I am building kernel with pos<0 check added...
 > 
 > thanks!  if it does not works, i have only one more idea(a patch
 > which removes some suspicious code which abuses a pointer any way that
 > has to be fixed properly ). otherwise i need to recreate the issue and
 > capture the stack trace completely, put debug prints. i ran an
 > overnight test but was unable to recreate the issue. later today AN  i
 > got a crash accidentally but only once, after that never.

What is a complete stack trace? Maybe I can configure console in some way and 
get the needed information.


