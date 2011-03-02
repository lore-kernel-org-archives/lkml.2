Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab1CBKnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:43:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57960 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab1CBKnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:43:50 -0500
Date: Wed, 2 Mar 2011 11:43:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86-64, NUMA: Fix distance table handling
Message-ID: <20110302104336.GA26381@elte.hu>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302100400.GK19669@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> >From dcd414c795a28fff6e511d58e4cfd1202323c703 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 2 Mar 2011 10:54:10 +0100

Btw., given that you basically took most of Yinghai's fixes, wouldnt it be better to 
have this as a 'From: Yinghai' commit, with -v2 comments about minor updates you 
did?

Thanks,

	Ingo
