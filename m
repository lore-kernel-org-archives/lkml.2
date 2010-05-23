Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0EWK1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 06:27:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:52975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0EWK1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 06:27:13 -0400
Message-ID: <4BF902F3.7030405@kernel.org>
Date: Sun, 23 May 2010 12:26:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched/core] sched: prepare for cmwq
References: <1273747705-7829-1-git-send-email-tj@kernel.org> <4BF1CD92.9030800@kernel.org> <4BF689DD.2090306@kernel.org> <20100523090544.GB25524@elte.hu> <4BF8F0A4.5060608@kernel.org> <20100523091306.GE25524@elte.hu> <4BF8F46A.1060407@kernel.org> <20100523102024.GA20869@elte.hu>
In-Reply-To: <20100523102024.GA20869@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 May 2010 10:27:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 05/23/2010 12:20 PM, Ingo Molnar wrote:
> Not exclusive to btrfs of course, but IIRC one of the examples given
> in one of those threads was btrfs scalability, right?

Hmmm... I don't think so.  If btrfs ever was mentioned, it must have
been pretty tangential.  Nothing rings a bell to me.

> In case it's not obvious, i'm trying to find a tangible improvement
> to examine. No need to resend stuff, do you have a link to that old
> performance measurement by any chance?

Sure.

 http://thread.gmane.org/gmane.linux.kernel/939353

Thanks.

-- 
tejun
