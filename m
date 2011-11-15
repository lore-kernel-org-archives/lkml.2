Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1KOLgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:36:13 -0500
Received: from usa7109mr002.acs-inc.com ([63.101.151.11]:65120 "EHLO
	USA7109MR002.ACS-INC.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1KOLgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:36:12 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Nov 2011 06:36:12 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhABAH5Lwk4Nl9IPmWdsb2JhbABDqWoiAQEBAQEICwsHFCWBcgEBAQMBDwEgCiUaBQsCAQgiBgwMBgFWAQEEARqHeqdoAZMaiSFjBIx4jHyDOoh8
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/3] mtd/nand: fix coding style issue in drivers/mtd/nand/fsl_elbc.c
Date: Tue, 15 Nov 2011 11:26:06 -0000
Message-ID: <929D3CED81F34E43887A393170D66FB9053A8C82@GBRSUN01MS002.eu.xerox.net>
In-Reply-To: <1321349355-1639-1-git-send-email-b35362@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] mtd/nand: fix coding style issue in drivers/mtd/nand/fsl_elbc.c
Thread-Index: Acyjg7csHEtwUMcaRrGVbyDx9hwbvgABDqgg
References: <1321349355-1639-1-git-send-email-b35362@freescale.com>
From: "Jenkins, Clive" <Clive.Jenkins@xerox.com>
To: <b35362@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <scottwood@freescale.com>, <akpm@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>
X-OriginalArrivalTime: 15 Nov 2011 11:26:09.0266 (UTC) FILETIME=[5F5CB520:01CCA389]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fix whitespaces,tabs coding style issue and ...

In my opinion this code was already correct, and would display correctly
at any TAB setting. This patch changes it so that it displays
incorrectly
at all TAB settings other than 8.

Example:

Correct:
<tabs>function(arg1,
<tabs><9spaces>arg2

Incorrect:
<tabs>function(arg1,
<tabs>< tab  > arg2

For any TAB setting other than 8, arg1 and arg2 no longer line up.

Clive
