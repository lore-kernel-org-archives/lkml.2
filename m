Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab2EVO7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:59:48 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:32193 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755448Ab2EVO7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:59:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VgIWFpEVM1k69tEHN6R99QFFKqh_ECBrFc1p8ySxJ.eBo6G
 lvqqUoNU6udbOWzEuA159khjiQ1bhTlFIA0blXFMnN2306jJHsDvRot60eOV
 dEUhUISzcJB3RaoKvc_FOr2SpgsfYvE1XPECTe0u4sj6HbL5mLc704QMcyZU
 ki2uUoM5UNn32jdFWmIWRKBoCd3B0oAs8upQHtL2ZZcpfd6TvNHAWF2WeZU_
 z9TvlkEeMNuWQPOCCmRxpyS7jbz5uu5pJVWUn46.CjKKqc5nPIUpxXqqoBGU
 xkKbARn0C5EB6kfLFKcr931.z_3lDSzztu8qUF_bRXjPXChhMjykx5c1xxDn
 ikX5Xwii5DieGcuF2Ysr92UJkhFHANNOpIg.E3mOWlLGVZtA_E_uDNG_cA8l
 Cj3bpv0zUwZLZl8AT1jR.4QkrSA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 May 2012 09:59:43 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] slab: move FULL state transition to an initcall
In-Reply-To: <1337695679-10178-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205220959290.17721@router.home>
References: <1337695679-10178-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux.com>

