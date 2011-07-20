Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1GTRNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:13:30 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:34096 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751415Ab1GTRN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:13:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3.L.JbIVM1kFO.YOxCxJJMakD4nCbXzSs4fRvxS6n5fbAP8
 FgYDAm9tqG02zFDd98b5xDGC5YkoPftjpo1UL6mPuC1N2EBdFqrEZ6g1QHzF
 R9jani0GXki5kKU5vBKHOZaMmLgK2y3YpEZD1jKQLrNr6afT6NkzSFYt7Mgb
 fkZFJ5AxBt7B7eSkXuDkd9I3b67hpS7Yg8XwlJr5zHQbfEF_UUgyViWq_qAw
 4VnV.Tc1zDNcnxZ0P3Z_ev3ubSuXPJ6zSDjti5TlXDf9SyXfEFzhxvRLzkUF
 eKvFujKkwqDcBN1EcFGlptA5r5eUdr95awVWJ7SNgx36Pn98EW9CDjebZu07
 mYA2xlNREBOdcSRUi.z.cPo8-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 12:13:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <1311181463.2338.72.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1107201212140.1472@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>  <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>  <alpine.DEB.2.00.1107200854390.32737@router.home>  <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> 
 <alpine.DEB.2.00.1107200950270.1472@router.home>  <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1107201033080.1472@router.home>  <1311177362.2338.57.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1107201114480.1472@router.home>
  <1311179465.2338.62.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1311181463.2338.72.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Eric Dumazet wrote:

> [PATCH v2] slab: shrinks sizeof(struct kmem_cache)

This will solve the issue for small nr_cpu_ids but those with 4k cpus will
still have the issue.

Acked-by: Christoph Lameter <cl@linux.com>
