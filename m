Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2GPR3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:29:41 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:46752 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752746Ab2GPR3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:29:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: kg1T07cVM1nDxnsHu5VQvd_hM8NoKwSuGhYWh.Spp9n6TXX
 Gsz7TfZzUbEsyzhsSSIs7f9sdiL9_650TA2SgxO.5HB6kK8fudgIlA.GjEc5
 WANxsY15EZPk0qoG86Q1yzealzCCMo2at6nQPKAbnK265LJ8VC6P428uEmNI
 oRK9de41wBTRzzr5VuPT0HsrOeJcSP6ASCZm7qExmZXyp53H4Ix5QhAiqcKx
 MYuR1CxLYgyvyiGNZoARXYWaWkmQA83SegXuR536OnTU7RBaNYomHr6IQyw3
 CW3Cmd.aIWwAsAkZtoxg.umj_Xs2zDGDqPYbYm1zkPwy3_QPGIjfSnRsiiak
 qQlm4D2303DFdGwQFNq7Xn.7npB7kRNCyAXS6zDxifcdXnY.yozSSBo_ic6H
 lQb4UC92UyHQwSpRmyWJr8V1iGTqa.CGY780-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 16 Jul 2012 12:29:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 3/3] mm: fix return value in
 __alloc_contig_migrate_range()
In-Reply-To: <1342455272-32703-3-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207161229200.32319@router.home>
References: <Yes> <1342455272-32703-1-git-send-email-js1304@gmail.com> <1342455272-32703-3-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Joonsoo Kim wrote:

> migrate_pages() would return positive value in some failure case,
> so 'ret > 0 ? 0 : ret' may be wrong.
> This fix it and remove one dead statement.

Acked-by: Christoph Lameter <cl@linux.com>
