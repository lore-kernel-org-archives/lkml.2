Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab0FCJCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:02:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51673 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab0FCJCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:02:32 -0400
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Michal Marek <mmarek@suse.cz>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/4] perf tools: Make target to generate self contained source tarball
From: Andi Kleen <andi@firstfloor.org>
References: <1275511215-25703-1-git-send-email-acme@infradead.org>
	<1275511215-25703-4-git-send-email-acme@infradead.org>
Date: Thu, 03 Jun 2010 11:02:29 +0200
In-Reply-To: <1275511215-25703-4-git-send-email-acme@infradead.org> (Arnaldo Carvalho de Melo's message of "Wed\,  2 Jun 2010 17\:40\:14 -0300")
Message-ID: <87k4qgxzdm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@infradead.org> writes:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Useful for when people want to try some version of the perf tools and don't
> wants to download the kernel tarball.

Does this also finally allow to build perf in a separate objdir like
the rest of the kernel?

Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
