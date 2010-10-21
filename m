Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab0JUUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:09:56 -0400
Received: from mail-zbox20.bo3.lycos.com ([209.202.250.20]:56087 "EHLO
	mailbox20.lycos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0JUUJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:09:55 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2010 16:09:55 EDT
Date: Thu, 21 Oct 2010 16:02:42 -0400 (EDT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <18536664.253751287691209904.JavaMail.root@mail-zbox20.bo3.lycos.com>
Subject: On Linux numbering scheme
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.17.79.151]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3028.CentOS5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello,



 As time passes by, the Linux numbering scheme makes even less sense. Some time ago there was a discussion on LKML about a new numbering scheme but it didn't come to any positive conclusion and then the subject was forgotten entirely. Not meaning to raise a clamour here (and I suppose I represent a large group of Linux users here). I'm willing to suggest a numbering scheme which I hope will answer all known complaints and criticism.



 The scheme is simple. We start either from 3.0.1 [.stable] or from 3.10.0 [.stable].



 The first digit will remain "3" forever, to preserve compatibility with all existing utilities and internal Linux kernel code. So, the concern about older utilities breakage is answered here: both 3.0.1 and 3.10.1 are bigger than any currently released kernel.



 The second number will be either 10 (the current year) or 0 meaning we have reset the numbering altogether. However in my opinion 10 sounds better than 0.



 Now, more about the second and third numbers. The second number is just the current year in the 21 century or the same number minus 10. The third number will be incremented with every new release until the next year hits. So, the real next year we'll have 3.11.1, 3.11.2, 3.11.3, etc.



 Now comes a problem, what if we release kernel 3.10.1 this year and the development of the next one commences also this year? What will be the next release number? I suggest to assign the next release number as the following:



 1) Either regardless the actual year the next kernel gets released (this way the kernel development started in 2010 will yield kernel 3.10.2 even though we hit the next year) or

 2) By the day the kernel gets released, so while in development the kernel version remained 3.10.1-rcX, on the 15th of January, we rename it to 3.11.1.


  Artem
