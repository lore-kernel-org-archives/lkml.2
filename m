Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab1KOOw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 09:52:56 -0500
Received: from mx0.aculab.com ([213.249.233.131]:44500 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751834Ab1KOOwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:52:55 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/3] mtd/nand: fix coding style issue in drivers/mtd/nand/fsl_elbc.c
Date: Tue, 15 Nov 2011 14:51:09 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AEC4@saturn3.aculab.com>
In-Reply-To: <1321362603.1932.67.camel@shinybook.infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] mtd/nand: fix coding style issue in drivers/mtd/nand/fsl_elbc.c
Thread-Index: Acyjl9v0GCaQq/sFQIO5NMlkE06mPQADaX3Q
From: "David Laight" <David.Laight@ACULAB.COM>
To: "David Woodhouse" <dwmw2@infradead.org>,
        "Jenkins, Clive" <Clive.Jenkins@xerox.com>
Cc: <Artem.Bityutskiy@nokia.com>, <b35362@freescale.com>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <scottwood@freescale.com>, <akpm@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>
X-OriginalArrivalTime: 15 Nov 2011 14:51:09.0324 (UTC) FILETIME=[02C49CC0:01CCA3A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On Tue, 2011-11-15 at 11:26 +0000, Jenkins, Clive wrote:
> > > fix whitespaces,tabs coding style issue and ...
> > 
> > In my opinion this code was already correct, and would display
correctly
> > at any TAB setting. This patch changes it so that it displays
> > incorrectly at all TAB settings other than 8.
> 
> Any tab setting other than 8 is incorrect and should not be used for
> Linux code. If I view it in a proportionally-spaced font, 
> it's not going to line up right either. Fix your editor, if that's an
issue for you.

Personally I don't even attempt to line up argumants on
continuation lines - it just wastes vertical space.
I just indent them as any other continuation line, so
double-indent if using 4-char indents and 1/2 indent for
8-char indents.

Tabs have to be assumed to be 8 columns, otherwise all sorts
of tools just get it wrong.
(Or you ban tabs from source files.)

	David


