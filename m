Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1KPJBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:01:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42853 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1KPJBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:01:01 -0500
Subject: Re: [PATCH] sched: add the inline keyword to the prototype.
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Il Han <corone.il.han@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Nov 2011 10:00:38 +0100
In-Reply-To: <4EC36631.8030805@google.com>
References: <1321380994-5768-1-git-send-email-corone.il.han@gmail.com>
	 <4EC36631.8030805@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321434038.1421.73.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 23:28 -0800, Paul Turner wrote:
> On 11/15/2011 10:16 AM, Il Han wrote:
> > The prototype has to agree with the definition.
> > Add the inline keyword to the prototype also
> >
> 
> Hmm... this would then cause the prototypes to disagree in the 
> !CONFIG_CFS_BANDWIDTH case.

I'm very sure I've compiled a lot of kernels yesterday with various
permutations including FAIR_GROUP && !CFS_BANDWIDTH and I'm also very
sure I haven't actually seen any complaints like this.

It this some new fangled GCC 'feature'? I'm currently still on 4.5 which
admittedly is somewhat stale.
