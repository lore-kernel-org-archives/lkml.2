Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2JVRal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:30:41 -0400
Received: from smtprelay0195.b.hostedemail.com ([64.98.42.195]:59754 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755015Ab2JVRaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:30:39 -0400
X-Panda: scanned!
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::::::::,RULES_HIT:152:355:379:541:582:599:601:960:988:989:1152:1260:1277:1311:1313:1314:1345:1358:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:3027:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3869:3870:3871:5007:6261:9010:10004:10400:10848:11658:11914:12296:12350:12517:12519,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1537
Date: Mon, 22 Oct 2012 17:30:37 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: stern@rowland.harvard.edu
Cc: zonque@gmail.com, bp@alien8.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <1985645001.39510.1350927037793.JavaMail.mail@webmail15>
References: <Pine.LNX.4.44L0.1210221153140.1724-100000@iolanthe.rowland.org>
Subject: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.147.62.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 22, 2012, Alan Stern <stern@rowland.harvard.edu> wrote: 

> A BUG() at these points would crash the machine hard.  And where we
> came from doesn't matter; what matters is the values in the pointers.

OK, here's what the kernel prints with your patch:

usb 6.1.4: ep 86 list del corruption prev: e5103b54 e5103a94 e51039d4

A small delay before I got thousands of list_del corruption messages would
have been nice, but I managed to catch the message anyway.

Artem

