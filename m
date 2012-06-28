Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2F1Gy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:54:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45954 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2F1Gyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:54:55 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-79-4febffb95dbc
From: "Kim, Jong-Sung" <neidhard.kim@lge.com>
To: "'Nicolas Pitre'" <nicolas.pitre@linaro.org>
Cc: "'Dave Martin'" <dave.martin@linaro.org>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        "'Chanho Min'" <chanho.min@lge.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>
References: <1338880312-17561-1-git-send-email-minchan@kernel.org> <025701cd457e$d5065410$7f12fc30$@lge.com> <20120627160220.GA2310@linaro.org> <00e801cd54f0$eb8a3540$c29e9fc0$@lge.com> <alpine.LFD.2.02.1206280223250.31003@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1206280223250.31003@xanadu.home>
Subject: RE: [PATCH] [RESEND] arm: limit memblock base address for early_pte_alloc
Date: Thu, 28 Jun 2012 15:54:49 +0900
Message-ID: <010e01cd54fa$e9c93fd0$bd5bbf70$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQLyw5u255N8mX4sZ4V+/prpc6IPugIAV1CoAy3QrR8BzxQbAAIE2lnulHxY1iA=
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nicolas Pitre [mailto:nicolas.pitre@linaro.org]
> Sent: Thursday, June 28, 2012 3:26 PM
> 
> On Thu, 28 Jun 2012, Kim, Jong-Sung wrote:
> 
> > Thank you for your comment, Dave! It was not that sophisticated
> > choice, but I thought that normal embedded system trying to reduce the
> > BOM would have a big-enough first memblock memory region. However
> > you're right. There can be exceptional systems. Then, how do you think
> about following manner:
> [...]
> 
> This still has some possibilities for failure.
> 
Can you kindly describe the possible failure path?

> Please have a look at the two patches I've posted to fix this in a better
> way.
> 
I'm setting up for your elegant patches. ;-)



