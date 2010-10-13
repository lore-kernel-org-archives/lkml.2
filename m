Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab0JMQKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:10:33 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:25625 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751390Ab0JMQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:10:32 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Gk_7xqwVM1mkm7KiOemYtPrhI.DZwi.TwtB1FMN6C.JbVPT
 Iu83GYbnMaxxbOGl59_cU4Z84bD9I8dqmHMokFkUe70Nw5AQ_PTsLRA1FfOj
 K3Gqn2IG3MpE2wUr.W.b90CihIpCQo0mBiIq2.CYrpUKRRihQ9UaI_8usQ8F
 pGlcey2R.rIpKYh0Q_FxNYMU4pmJu5ilUyiQaFx4jTMMFyLCoDSBwI207mn2
 Z
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Oct 2010 11:10:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, npiggin@kernel.dk,
        yanmin_zhang@linux.intel.com
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
In-Reply-To: <20101012182531.GH30667@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1010131109250.29099@router.home>
References: <20101005185725.088808842@linux.com> <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com> <20101012182531.GH30667@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Mel Gorman wrote:

> mm/slub.c:1748: error: `cpu_info' undeclared (first use in this function)
>
> I didn't look closely yet but cpu_info is an arch-specific variable.
> Checking to see if there is a known fix yet before setting aside time to
> dig deeper.

Argh we have no arch independant way to figuring out the shared cpu mask?
The scheduler at least needs it. Need to look at it when I get back from
the conference next week.

