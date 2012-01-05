Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2AESwW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 5 Jan 2012 13:52:22 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:41673 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab2AESwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:52:21 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Thu, 05 Jan 2012 22:52:17 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.178.216.22
Message-ID: <NEXT-4f05f161bfc4a1.14981770@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > :) no problem. i hope for you can recreate the issue consistently ,
>  > can you please test with the attached patch and another debug patch.
>  > please let me know if there is no panic but there are warnings (or) if
>  > there are no warnings (or) the issue still appears(also the trace
>  > thanks) , also if you need any help
> 
> Should I apply the patch to Linux 3.2-rc7 or 3.2 release?

Oh, I see. 3.2 release has this fix already. I will build it with debugging 
patch and report warnings now.


