Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0H0GLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 02:11:24 -0400
Received: from [210.51.52.178] ([210.51.52.178]:40001 "EHLO mail.newtouch.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0H0GLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 02:11:22 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2010 02:11:22 EDT
Message-ID: <01b901cb45ab$39165480$3c64a8c0@newtouch.nt>
From: =?iso-2022-jp?B?GyRCPGtKODJCGyhC?= <wenjia.zhu@newtouch.cn>
To: <linux-kernel@vger.kernel.org>
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
Subject: msgrcv() errno 514 ERESTARTNOHAND
Date: Fri, 27 Aug 2010 13:46:40 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List：

　I have a problem with msgrcv().

  I have used msgrcv() in my source to receive messages in a while(1).

  But it returned an error in errno 514(ERESTARTNOHAND).

  I search this error in net, and it seems to be should not happen in user program.

  But it happened in my program, and once only. I didn’t see it happens after that once.

 

  My question is how can I make this error happen again?

And how can I fix it?

 

 I saw RedHat has fixed the problem, but no details on their website.

 

My OS is Montavista 5.0(Kernel2.6.18).



Thanks


