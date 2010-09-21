Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0IUJ7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:59:06 -0400
Received: from sr-smtp.usish.com ([210.5.144.203]:60548 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0IUJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:59:05 -0400
From: "Jack Wang" <jack_wang@usish.com>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Cc: "'Kernel Testers List'" <kernel-testers@vger.kernel.org>,
        "'Maciej Rutecki'" <maciej.rutecki@gmail.com>,
        "'Florian Mickler'" <florian@mickler.org>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera> <Wn2eLj_6KZG.A.0qG.DE7lMB@chimera>
Subject: RE: [Bug #18862] [BUG]Kernel 2.6.36rc4 crash when rmmod pm8001
Date: Tue, 21 Sep 2010 17:56:58 +0800
Message-ID: <3188494C116B49AE985B773F69378515@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <Wn2eLj_6KZG.A.0qG.DE7lMB@chimera>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Thread-Index: ActY+mY02Tvr8fzhTxCXoCBprm11QAAeAAzw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rafael and list

I recompile a clean 2.6.36rc4 kernel, and try to reproduce this BUG, but I
cound not make this appear any more, sorry for that, maybe I hit the bug
during I
debug the libsas bug, sorry!

Jack


This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the
tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18862
Subject		: [BUG]Kernel 2.6.36rc4 crash when rmmod pm8001
Submitter	: Jack Wang <jack_wang@usish.com>
Date		: 2010-09-17 10:11 (4 days old)
Message-ID	: <3219F4D1734640238A632382C50F633E@usish.com.cn>
References	: http://marc.info/?l=linux-kernel&m=128471846828998&w=2


