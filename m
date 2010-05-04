Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab0EDKPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:15:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45938 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0EDKPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:15:46 -0400
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: perf, ftrace and MCEs
From: Andi Kleen <andi@halobates.de>
References: <20100501181212.GA25352@liondog.tnic>
Date: Tue, 04 May 2010 12:15:44 +0200
In-Reply-To: <20100501181212.GA25352@liondog.tnic> (Borislav Petkov's message of "Sat, 1 May 2010 20:12:12 +0200")
Message-ID: <87tyqo3rcf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> so I finally had some spare time to stare at perf/ftrace code and ponder
> on how to use those facilities for MCE collecting and reporting. Btw, I

A good beginning of any such investigations would be to describe
what exact problems you're trying to solve here.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
