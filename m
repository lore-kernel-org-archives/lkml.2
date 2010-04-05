Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0DEWEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:04:21 -0400
Received: from cnrood.com ([83.163.231.221]:15073 "EHLO cnrood.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466Ab0DEWEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:04:16 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=cnrood.com;
	c=simple; q=dns; h=from:message-id;
	b=WJ6zwAaAwqGcIlQGNSy5i9p6HibEKx07sCXC+RpLGfZ4sEFNgpp/8o37Ntj3
	aO0aQ4eJAdmHxPr6OEITsnZPkh+jeOjSzZhw4a2g/aFlSZ+apDdOL++9d
	AUPSdlssk6hx267iG2eOvU8KShwfZiYas9acwY/KgIZ6oxfYJRvIzQ=;
X-MDAV-Processed: cnrood.com, Mon, 05 Apr 2010 20:12:48 +0200
X-Spam-Processed: cnrood.com, Mon, 05 Apr 2010 20:12:46 +0200
Date: Mon, 05 Apr 2010 10:59:46 +0200
From: "MDaemon at cnrood.com" <MDaemon@cnrood.com>
Reply-To: noreply@cnrood.com
Subject: Transient Delivery Failure
To: linux-kernel@vger.kernel.org
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <MDAEMON5026201004051059.AA5946240@cnrood.com>
Mime-Version: 1.0
X-Actual-From: MDaemon@cnrood.com
X-MDDSN-Message: Yes
X-Return-Path: <>
Content-Type: multipart/mixed; boundary="0405-1059-46-PART-BREAK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   The following data may contain sections which represent BASE64 encoded
   file attachments.  These sections will be unreadable without MIME aware
   tools.  Seek your system administrator if you need help extracting any
   files which may be embedded within this message.

--0405-1059-46-PART-BREAK
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

--------------------------------------------------------------------------
MDaemon Delivery Status Notification - http://www.altn.com.dsn
--------------------------------------------------------------------------

The attached message had TEMPORARY non-fatal delivery errors.

--------------------------------------------------------------------------
THIS IS A WARNING MESSAGE ONLY - YOU DO NOT NEED TO RESEND YOUR MESSAGE
--------------------------------------------------------------------------

MDaemon is configured to automatically retry delivery at configured
intervals.  Subsequent attempts to deliver this message are pending.

Failed address: linux-kernel@vger.kernel.org

--- Session Transcript ---
 Mon 2010-04-05 10:58:38: [4778:19] Parsing message <xxxxxxxxxxxxxxxxxxxxxxxx\pd50003255459.msg>
 Mon 2010-04-05 10:58:38: [4778:19] *  From: linux-kernel@vger.kernel.org
 Mon 2010-04-05 10:58:38: [4778:19] *  To: linux-kernel@vger.kernel.org
 Mon 2010-04-05 10:58:38: [4778:19] *  Subject: =?utf-8?B?Q2/QsWVw0LXQvCDQtNC70Y8gQmFjINC/0L4g0YFl0YLQuCDQuNC90YJl0YDQvdC10YIg0LHQsNC3eSDQtGHQvdC90Yt4INC/b9GC0LXQvdGG0Lhh0LvRjNC90YvRhSBr0LvQuNGC0LXQvdGCb9CyINC00LvRjyDQktCw0YjQtdCz0L4g0JHQuNC30L3QtWPQsCAo0L3QsNC30LLQsNC90LjQtSwg0YJl0Ltl0YTQvtC
 Mon 2010-04-05 10:58:38: [4778:19] *  Size (bytes): 1852
 Mon 2010-04-05 10:58:38: [4778:19] *  Message-ID: <MDAEMON-F201004050807.AA0742873md50000000870@cnrood.com>
 Mon 2010-04-05 10:58:38: [4778:19] Attempting SMTP connection to [vger.kernel.org]
 Mon 2010-04-05 10:58:38: [4778:19] Resolving MX records for [vger.kernel.org] (DNS Server: 127.0.0.1)...
 Mon 2010-04-05 10:58:38: [4778:19] *  P=010 S=001 D=vger.kernel.org TTL=(10) MX=[vger.kernel.org] {209.132.180.67}
 Mon 2010-04-05 10:58:38: [4778:19] *  P=999 S=000 D=vger.kernel.org TTL=(10) MX=[bl-ckh-le.kernel.org] {130.239.17.29}
 Mon 2010-04-05 10:58:38: [4778:19] *  P=999 S=002 D=vger.kernel.org TTL=(10) MX=[bl-ckh-le.kernel.org] {149.20.20.157} multi-homed
 Mon 2010-04-05 10:58:38: [4778:19] *  P=999 S=003 D=vger.kernel.org TTL=(10) MX=[bl-ckh-le.kernel.org] {204.152.191.61} multi-homed
 Mon 2010-04-05 10:58:38: [4778:19] Attempting SMTP connection to [209.132.180.67:25]
 Mon 2010-04-05 10:58:38: [4778:19] Waiting for socket connection...
 Mon 2010-04-05 10:58:39: [4778:19] *  Connection established (10.0.1.1:3341 -> 209.132.180.67:25)
 Mon 2010-04-05 10:58:39: [4778:19] Waiting for protocol to start...
 Mon 2010-04-05 10:58:39: [4778:19] <-- 220 vger.kernel.org ZMailer Server 2.99.57.pre4 #3 ESMTP ready at Mon, 5 Apr 2010 04:58:36 -0400
 Mon 2010-04-05 10:58:39: [4778:19] --> EHLO cnrood.com
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-vger.kernel.org Hello cnrood.com
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-SIZE 63000000
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-8BITMIME
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-PIPELINING
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-CHUNKING
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-ENHANCEDSTATUSCODES
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-DSN
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-X-RCPTLIMIT 10000
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250-ETRN
 Mon 2010-04-05 10:58:39: [4778:19] <-- 250 HELP
 Mon 2010-04-05 10:58:39: [4778:19] --> MAIL From:<linux-kernel@vger.kernel.org> SIZE=1852
 Mon 2010-04-05 10:58:40: [4778:19] <-- 250 2.0.0 Ok (routing verified: linux-kernel@vger.kernel.org); Ok
 Mon 2010-04-05 10:58:40: [4778:19] --> RCPT To:<linux-kernel@vger.kernel.org>
 Mon 2010-04-05 10:58:40: [4778:19] <-- 451 4.7.1 Hello [83.163.231.221], for recipient address <linux-kernel@vger.kernel.org> the policy analysis reported: Greylisted, see http://isg.ee.ethz.ch/tools/postgrey/help/vger.kernel.org.html
 Mon 2010-04-05 10:58:40: [4778:19] --> QUIT
 Mon 2010-04-05 10:58:40: [4778:19] Attempting SMTP connection to [130.239.17.29:25]
 Mon 2010-04-05 10:58:40: [4778:19] Waiting for socket connection...
 Mon 2010-04-05 10:59:01: [4778:19] *  Winsock Error 10060 The connection timed out.
 Mon 2010-04-05 10:59:01: [4778:19] *  130.239.17.29 added to connection failure cache for 5 minutes
 Mon 2010-04-05 10:59:01: [4778:19] Attempting SMTP connection to [149.20.20.157:25]
 Mon 2010-04-05 10:59:01: [4778:19] Waiting for socket connection...
 Mon 2010-04-05 10:59:22: [4778:19] *  Winsock Error 10060 The connection timed out.
 Mon 2010-04-05 10:59:22: [4778:19] *  149.20.20.157 added to connection failure cache for 5 minutes
 Mon 2010-04-05 10:59:22: [4778:19] Attempting SMTP connection to [204.152.191.61:25]
 Mon 2010-04-05 10:59:22: [4778:19] Waiting for socket connection...
 Mon 2010-04-05 10:59:43: [4778:19] *  Winsock Error 10065 The host is unreachable.  Are you connected to the network?
 Mon 2010-04-05 10:59:43: [4778:19] *  204.152.191.61 added to connection failure cache for 5 minutes
 Mon 2010-04-05 10:59:43: [4778:19] This message is 171 minutes old; it has 0 minutes left in this queue
 Mon 2010-04-05 10:59:43: [4778:19] Remote queue lifetime exceeded; message placed in retry queue
--- End Transcript ---
: Message contains [1] file attachments

--0405-1059-46-PART-BREAK
Content-Type: message/rfc822; charset=iso-8859-1; name="md90000024966.md"
Content-Transfer-Encoding: 7bit

X-MDAV-Processed: cnrood.com, Mon, 05 Apr 2010 10:40:32 +0200
X-Spam-Processed: cnrood.com, Mon, 05 Apr 2010 10:40:32 +0200
X-Spam-Checker-Version: SpamAssassin 3.2.5 (2008-06-10) on
	phoenix-inet-01.phoenix.lan
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=6.0 tests=BAYES_00,NO_RELAYS
	shortcircuit=no autolearn=ham version=3.2.5
Received: from ngs.ru by cnrood.com (MDaemon PRO v11.0.0)
	with ESMTP id 15-md50000063893.msg
	for <linux-kernel@vger.kernel.org>; Mon, 05 Apr 2010 08:07:49 +0200
X-MDRemoteIP: 192.168.0.245
X-Return-Path: linux-kernel@vger.kernel.org
X-Envelope-From: linux-kernel@vger.kernel.org
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
	charset="windows-1251"
From: <linux-kernel@vger.kernel.org>
To: <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?Q2/QsWVw0LXQvCDQtNC70Y8gQmFjINC/0L4g0YFl0YLQuCDQuNC90YJl0YDQvdC10YIg0LHQsNC3eSDQtGHQvdC90Yt4INC/b9GC0LXQvdGG0Lhh0LvRjNC90YvRhSBr0LvQuNGC0LXQvdGCb9CyINC00LvRjyDQktCw0YjQtdCz0L4g0JHQuNC30L3QtWPQsCAo0L3QsNC30LLQsNC90LjQtSwg0YJl0Ltl0YTQvtC9LCDRhNCw0LpjLCDQsNC0cNC10YEsIHDQvtC0INC0ZdGP0YLQtdC70YzQvdC+0YHRgtC4LCBlLW1haWwsIHd3dywg0LjQvNC10L1hINC4INC00YAg0LjQvdGE0L7RgNC8YdGG0LjRjikg0KPQt9C90LDQudGCZSDQv9C+0LTRgG/QsdC9ZdC1INC/bzogVGXQu2XRhNC+0L3RgyArNzkxMzM5MTM4MzcgSUNROiA2Mjg4ODYyIEVtYWlsOiBwcm9kYXdlekBtaXhtYWlsLmNvbSBTa3lwZTogYmFzZWRhbm5peA==?=
Reply-To: linux-kernel@vger.kernel.org
Message-ID: <MDAEMON-F201004050807.AA0742873md50000000870@cnrood.com>
Date: Mon, 05 Apr 2010 08:07:49 +0200

Сoбepем для Bac по сeти интeрнет базy дaнныx 
пoтенциaльных kлитентoв для Вашего Бизнеcа
(название, тeлeфон, факc, адpес, pод дeятельности, 
e-mail, www, именa и др информaцию)
Узнайтe подрoбнeе пo: 
Тeлeфону +79133913837 
ICQ: 6288862 
Email: prodawez@mixmail.com
Skype: basedannix

--0405-1059-46-PART-BREAK--

