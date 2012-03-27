Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2C0Vwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:52:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2C0Vwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:52:42 -0400
Message-ID: <1332885154.2528.2.camel@twins>
Subject: Re: [tip:perf/urgent] perf/x86: Add SNB offcore event constraints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Tue, 27 Mar 2012 23:52:34 +0200
In-Reply-To: <tip-n6vf6grjv94vnzvuccu0clcv@git.kernel.org>
References: <tip-n6vf6grjv94vnzvuccu0clcv@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 08:36 -0700, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  c370117c978adba861fad467427a9301c2c7082b
> Gitweb:     http://git.kernel.org/tip/c370117c978adba861fad467427a9301c2c7082b
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 22 Mar 2012 11:41:23 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 27 Mar 2012 14:53:46 +0200
> 
> perf/x86: Add SNB offcore event constraints
> 
> As found in the Intel SDM (March 2012 edition) in Volume 3
> section 18.8.5, the offcore response events are constrained
> to PMC0 and PMC3 resp..

Ingo, Stephane talked to some Intel folks and the SDM was wrong, can you
make this here patch go away?


