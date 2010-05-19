Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0ESQAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:00:46 -0400
Received: from web4212.mail.ogk.yahoo.co.jp ([124.83.212.32]:47052 "HELO
	web4212.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752847Ab0ESQAp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:00:45 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 12:00:44 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=kmaJglp3ZK5q1FdA6Dk1zL0nqx74VUQMH+0YPS+cTu9VPgqtszUYySarsaQBZ6LRIZY3eB4FYJpoZ17o1+Gmtzdv3mGlDwqiMq7AcJMoFBBRmrLt4l8YY3eDQQz/uX2A  ;
Message-ID: <436250.99909.qm@web4212.mail.ogk.yahoo.co.jp>
X-YMail-OSG: OAZmC7cVM1l4GNpKrz1pCtpVzPmq9RMU3d7662qfx.7sKil3pOuw.hSn79AC_fRjeRs.hs0Zl4ay4Gf5OWAJhugY0QaePJN8xb33ivAPUbnBnq8_HO7nfL09tQONfLVnfERB0rVSQYbew3T9Xl8RG_FCpwW2b9O0QacxxB1wew1QiaOraGQazdoMisuVY7T8Q7QC0Tx1OtDhA22CHeaSiSfxe6SJiBNGnVOwuKTOu9TtSRZfMpAYXeZhxdQqP_fl
X-Mailer: YahooMailWebService/0.7.289.12_20
Date: Thu, 20 May 2010 00:54:01 +0900 (JST)
From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: timer/hrtimer: how do they work
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am trying to understand how timer/hrtimer work.
I am not yet clear about the following points. Please help.

I understand that there are two types of timer queues:
   - timer wheel
   - hrtimer

I also understand that there are separate sets of APIs
for adding and removing timers into those queues.

Now I want to  understand:
   - when and how the timers are armed
   - how are they processed when fired

When and how the timers are armed:

For hrtimers, it seems that they are armed in hrtimer_interrupt.
Where are the timer wheel timers armed?

How are they processed when fired:

For hrtimers, it seems that they are processed in hrtimer_run_queues.
Where are the timer wheel timers processed?

Is there any doc or something which may help me understand
the call sequence of the related source code?

Thanks
RR

--------------------------------------
2010 FIFA World Cup News [Yahoo!Sports/sportsnavi]
http://pr.mail.yahoo.co.jp/southafrica2010/
