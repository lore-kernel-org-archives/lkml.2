Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab2HYAgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 20:36:00 -0400
Received: from plane.gmane.org ([80.91.229.3]:42604 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab2HYAf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 20:35:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ed Cashin <ecashin@coraid.com>
Subject: Re: [PATCH 02/14] aoe: kernel thread handles I/O completions for simple locking
Date: Fri, 24 Aug 2012 20:35:41 -0400
Message-ID: <m2a9xj6c6a.fsf@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
	<752ecb77a67b4ba55e8f3ebddd745491aacc8818.1345743801.git.ecashin@coraid.com>
	<20120824142257.cbfb21a6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
Cc: Andrew Morton <akpm@linux-foundation.org>, ecashin@coraid.com
X-Gmane-NNTP-Posting-Host: c-98-192-52-118.hsd1.ga.comcast.net
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (darwin)
Cancel-Lock: sha1:pYIPC2z4QWNWwWI5CbVSBnOpHck=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 17 Aug 2012 21:24:08 -0400
> Ed Cashin <ecashin@coraid.com> wrote:
...
>> +	sigfillset(&blocked);
>> +	sigprocmask(SIG_BLOCK, &blocked, NULL);
>> +	flush_signals(current);
>
> This is a kernel thread - it shouldn't need to fiddle with signals.
...

Thanks for the feedback.  I'll try out your suggestions and return with
changes and explanations.

-- 
  Ed

