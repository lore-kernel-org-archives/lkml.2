Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab2IGTLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:11:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36355 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2IGTLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:11:09 -0400
Message-ID: <1347045062.2124.7.camel@twins>
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 21:11:02 +0200
In-Reply-To: <20120907171845.GL8285@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
	 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
	 <20120906190238.GA29278@erda.amd.com> <5048F6BF.70106@gmail.com>
	 <20120906195645.GD8285@erda.amd.com> <20120907164114.GJ8285@erda.amd.com>
	 <1347036987.2124.3.camel@twins> <20120907171845.GL8285@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 19:18 +0200, Robert Richter wrote:
> I was thinking of this too. But this breaks existing code to compile
> since static initialization of struct perf_event_attr fails, e.g.:
> 
>  builtin-test.c:469:3: error: unknown field ‘watermark’ specified in initializer
> 
> 
Oh bugger, I only compiled the kernel part :/


