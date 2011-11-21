Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1KURP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:15:58 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:26381 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751623Ab1KURP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:15:57 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0165lkgVM1mg.bc9PgMvTl8Uqqk7LRthbWoXoFHm75yxk3p
 kNYW9SdVcwZVYz48rRHkXOj09f7arj1YNdEgUWBuM6ZRz8nXfXxGhaLbUFKI
 DTGtuvwOcTxc08nTL7ORVV5ENQbT5JaMAMPNuN8pY8Ah8kOIgRW3T0WMJM9t
 iyVr3cDQuinKrtUke7AgdNQCRDUiZOaKG1BFex0UDmLPLFMkppDXyrWW8u.L
 0toP9Q4WFG0LMuAP0xLDLQJbyY7JDXljloMChmSXVGIk90aKeH7YG6rC5M7s
 SIrOKutFbQVEFcTvL7DaRSe8Mu3LqH2JQnxGf7hl0_svB4CfWxhembIif5Eq
 0pR4PtsQO3bFteCj4I1hVDwVX2GbXQbxZ1uV.WbLREAjS4Q--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 21 Nov 2011 11:15:54 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v3 3/3] slub: min order when debug_guardpage_minorder >
 0
In-Reply-To: <1321633507-13614-3-git-send-email-sgruszka@redhat.com>
Message-ID: <alpine.DEB.2.00.1111211115380.4771@router.home>
References: <1321633507-13614-1-git-send-email-sgruszka@redhat.com> <1321633507-13614-3-git-send-email-sgruszka@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011, Stanislaw Gruszka wrote:

> Disable slub debug facilities and allocate slabs at minimal order when
> debug_guardpage_minorder > 0 to increase probability to catch random
> memory corruption by cpu exception.

Acked-by: Christoph Lameter <cl@linux.com>
