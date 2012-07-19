Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2GSQIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:08:24 -0400
Received: from web100708.mail.kks.yahoo.co.jp ([183.79.100.12]:23900 "HELO
	web100708.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751707Ab2GSQIQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:08:16 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 12:08:16 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20110701; d=yahoo.co.jp;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=daEPYlSeLUlqFErTH2pvwzRMNkdW2bUM5lznoGiyzxcYl96a1KVPklC/aK8eoTNTAWoyQYYl5CyDUQQXv682FsG7GUhS9ElfL2TNwsRUBoH7t7QehaoWnGJkc+Uy6tDe3trZDUUfM+UTMe5xWw0YrhXLanScGba7ueVoOc/29Q8=;
Message-ID: <877727.54297.qm@web100708.mail.kks.yahoo.co.jp>
X-YMail-OSG: 7__E_DoVM1mM3BWMA..qxJkpdpPJajSCYDs359AKJT389H4NhE_RzYMy3H0BeFXHb10lZjiIEaasgDBSs5Q0mQevAOwpZRFMYZosn0af7.J85pUQl0N8nHWHkd6xM5j1xHVJwrPxQxm0KnCHPKAeAWk38L0eZUvdxKvivN4Edv5q388T.mP8ZzfCznrnwljriYjT5AWm16Jh08ak6zax7ao8c2FDTgECf2g.pfvV0VKno0LsUD6hCmzgeKWiZIE5re_YUdWOkQ--
X-Mailer: YahooMailWebService/0.8.111_26
Date: Fri, 20 Jul 2012 01:01:34 +0900 (JST)
From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Reply-To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: workqueue and kworker
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
 
It seems that even if you create a dedicated workqueue
in your driver, it does not give you a dedicated
kworker thread. Is this normal behaviour?
If so, then what is the difference between using
generic workqueue and dedicated workqueue?
 
I need to set the priority of my kworker thread high
(a specific value). For that I called sched_setscheduler()
in my workqueue handler. But I found that other
workqueues are also being executed on my high priority
kworker thread which is unexpected.
How do I give high priority to my kworker thread
without affecting the behaviour of other workqueues?
 
Thanks
RR
