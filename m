Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1BVKan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:30:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab1BVKam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:30:42 -0500
Date: Tue, 22 Feb 2011 11:30:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86-64, NUMA: Seperate out numa_alloc_distance() from
 numa_set_distance()
Message-ID: <20110222103030.GA22248@elte.hu>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC19A.9030808@kernel.org>
 <20110221104803.GK31267@htj.dyndns.org>
 <4D62A2A4.7060701@kernel.org>
 <20110222102357.GW31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222102357.GW31267@htj.dyndns.org>
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

> Alloc code is much bigger the distance setting.  Separate it out into
> numa_alloc_distance() for readability.

FYI, the From: Yinghai line seems to be missing. If this patch is committed as-is 
then you will be the author.

Thanks,

	Ingo
