Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1KOOmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 09:42:33 -0500
Received: from usa7109mr001.acs-inc.com ([63.101.151.9]:36369 "EHLO
	USA7109MR001.ACS-INC.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1KOOmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:42:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4AAFp5wk4Nl9IPmWdsb2JhbABEhQGjZ4EGIgEBAQEBCAsLBxQlgXIBAQEDAQ8BEw0EKxoQAgEIDgwCBgYMDAICAgEBVQEBBBuHeqYJAWmSJ4Ewh0szYwSMeox8gzqIfA
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH 1/3] mtd/nand: fix coding style issue in drivers/mtd/nand/fsl_elbc.c
Date: Tue, 15 Nov 2011 14:42:25 -0000
Message-ID: <929D3CED81F34E43887A393170D66FB9053A8F81@GBRSUN01MS002.eu.xerox.net>
In-Reply-To: <1321362603.1932.67.camel@shinybook.infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] mtd/nand: fix coding style issue in drivers/mtd/nand/fsl_elbc.c
Thread-Index: Acyjl++dR+93/UlZS42aWYH3s5AL3gACx5tw
References: <1321349355-1639-1-git-send-email-b35362@freescale.com> <929D3CED81F34E43887A393170D66FB9053A8C82@GBRSUN01MS002.eu.xerox.net> <1321362603.1932.67.camel@shinybook.infradead.org>
From: "Jenkins, Clive" <Clive.Jenkins@xerox.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Cc: <b35362@freescale.com>, <Artem.Bityutskiy@nokia.com>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <scottwood@freescale.com>, <akpm@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>
X-OriginalArrivalTime: 15 Nov 2011 14:42:29.0645 (UTC) FILETIME=[CD03E3D0:01CCA3A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAFEgetV024034

> > > fix whitespaces,tabs coding style issue and ...
> > 
> > In my opinion this code was already correct, and would display correctly
> > at any TAB setting. This patch changes it so that it displays
> > incorrectly at all TAB settings other than 8.
>
> Any tab setting other than 8 is incorrect and should not be used for
> Linux code.

This may be your (not so humble :-) opinion, and I happen to agree that
a tab setting of 8 is best, usually. However, as Linus says in his
coding style document "Coding style is very personal, and I won't _force_
my views on anybody".

> ... Fix your editor, if that's an issue for you.

My editor has a tab setting of 8, but readers of this list have diverse
email clients, some of which do not display 8 spaces per tab.

Clive
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
