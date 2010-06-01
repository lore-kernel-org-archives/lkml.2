Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0FAK3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:29:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:48726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab0FAK3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:29:01 -0400
Message-ID: <4C04E0EA.8010100@suse.cz>
Date: Tue, 01 Jun 2010 12:28:58 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.18 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] perf tools: Make target to generate self contained
 source tarball
References: <20100528185357.GA28009@ghostprotocols.net> <20100529072948.GE16257@merkur.ravnborg.org> <20100531174207.GB3481@ghostprotocols.net> <4C0417EC.8050906@suse.cz> <20100531230639.GD3481@ghostprotocols.net>
In-Reply-To: <20100531230639.GD3481@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.6.2010 01:06, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 31, 2010 at 10:11:24PM +0200, Michal Marek escreveu:
>> On 31.5.2010 19:42, Arnaldo Carvalho de Melo wrote:
>>> +git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \
>>
>> If you use plain "HEAD" (a commit-ish) instead if HEAD^{tree}, then
>> git archive will store the commit id in the archive metadata and the
>> user can then use git get-tar-commit-id to extract it.
> 
> I just used what was in git.git and then when talking with a git
> enthusiast, he showed me this:
> 
> [acme@emilia git]$ git show 9cd625b79babaf50f50a0e5d96903eaacb1ee600
> commit 9cd625b79babaf50f50a0e5d96903eaacb1ee600
> Author: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
> Date:   Sun Jun 18 15:25:33 2006 +0200
> 
>     Make release tarballs friendlier to older tar versions

...

Ah, ok.


> Well, what about the other aspects of the patch, is this the only issue
> you have found with it?

The patch is OK.

Acked-by: Michal Marek <mmarek@suse.cz>

Michal
