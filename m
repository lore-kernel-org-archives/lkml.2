Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab0LNQVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:21:46 -0500
Received: from nm18-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.214]:30393 "HELO
	nm18-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757597Ab0LNQVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:21:44 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 245337.55264.bm@omp1003.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=odLNcM+BvRWwqshB5erfbrZ8A5BObVqpZWokxqzuo3Wmr1u7hpUjs1sOFhSddwn0sv9/TkwxF3iHXP+iY9SmS5EzBqY5QvcCuUT2ttZJzDBpxgNgohGS7XlG1gUSZwXqudT59xLTComtjVIUjEiUY8/jtyRhFb7XuYIk9LecKJ4=;
Message-ID: <636999.52551.qm@web180309.mail.gq1.yahoo.com>
X-YMail-OSG: DAr5yJwVM1nfZITMn5JTZQArW6yNcqpBdv6QYxEcnL.KAeV
 B0tQi3e0eSB1.uMBqrRIbx6vje4vOqxfF0KOjQPpWjOh7SkugsanRrLRs7vt
 k.hoIkiyT5mQMHOt2RswAzWK47OCRP7x9u1Zvvhl4Q0Y65TlODqdw49poJv3
 LR9cM_.ec8WjTLjxasRLPOhQN08siq4yVbZ2Yt8koykVkc13HBtbF9y_8x_o
 35mJwN2LqzUPfdhfhq4Hlg0bDrQCvuA0duLDdPvgwhLBqKXlfzDeOVZekIbW
 NJBDeIUIqgdEePuig_JNYGQfylD4_CZSwiynbK_CbiqUd.eTD1.aX6HMHlyJ
 X3nqU8KMfQdMq5s0qDvy3OfDNskZOHPWBayeXSmtJtAgaIGYrDpz3pBi4PZa
 u4140TXPeLan_ZISDqJO2
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Tue, 14 Dec 2010 08:21:43 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] AT91: usb gadget: fix freeing irq in _udc_remove()
To: gregkh@suse.de, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Emanuele <rje@crystalfontz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
In-Reply-To: <1292339139-26212-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You _do_ know that $SUBJECT references
an entirely different driver than $PATCH ...

