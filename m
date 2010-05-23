Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0EWJJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:09:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:40175 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab0EWJJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:09:03 -0400
Message-ID: <4BF8F0A4.5060608@kernel.org>
Date: Sun, 23 May 2010 11:08:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched/core] sched: prepare for cmwq
References: <1273747705-7829-1-git-send-email-tj@kernel.org> <4BF1CD92.9030800@kernel.org> <4BF689DD.2090306@kernel.org> <20100523090544.GB25524@elte.hu>
In-Reply-To: <20100523090544.GB25524@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 May 2010 09:08:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 05/23/2010 11:05 AM, Ingo Molnar wrote:
> IIRC these changes are for some sort of speedup for btrfs, 
> right?

Eh.... What are you talking about?  These are for cmwq.  The "must
unify scheduler notification hooks", "nah, if always enabled, go with
hard coded hooks" stuff.

Thanks.

-- 
tejun
