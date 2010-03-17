Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab0CQBr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 21:47:56 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:44228 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0CQBry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 21:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F+wj5mNoEmOkYjOUBbHcj1DTi9rihxga1PyAPCe2jDxalfhhtF5zXIC5J5yjaEtFx+
         USCkkwfiCkWqm5aRI28wwFnIwc0rL6z3Xh31ew2JplWUKuVpK5aVozcZuI07cGFnzN6m
         IsbkQO37qMmMBEZHB/9zmrG8EUv5IMhKRxFok=
Date: Wed, 17 Mar 2010 02:47:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100317014755.GC5258@nowhere>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 07:38:37PM +0900, Hitoshi Mitake wrote:
> I implemented it on the branch perf/inject of Frederic's random-tracing tree.
> Because the branch is hottest place of lock and tracing :)


Ouch! You shouldn't do this. The patches inside were
trials submitted for review and the resulting discussion
concluded that the injection must be redesigned.

More generally I don't recommend you to base your patches
on my tree. I use it as a buffer when I send patches
for review or for pull requests.

The branches inside can be randomly rebased (unless a
branch is waiting to be pulled) and they are pretty async
with the -tip tree.

The hottest and most sync tree on which you should base your patches
for perf is:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
	perf/core

With that you have best chances to work on a sane and up-to-date
base.

Thanks.

