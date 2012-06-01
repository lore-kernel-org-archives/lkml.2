Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2FACul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:50:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43958 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2FACuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:50:40 -0400
X-AuditID: 9c93016f-b7c3cae000001954-b9-4fc82dfc431c
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "John 'Warthog9' Hawley" <warthog9@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/22] perf tools: Backport of latest changes on trace-cmd's libparseevent
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
	<87hauwnash.fsf@sejong.aot.lge.com>
	<20120531145230.GF13591@infradead.org>
	<1338476986.13348.347.camel@gandalf.stny.rr.com>
	<20120531151356.GG13591@infradead.org>
	<20120531152242.GB27841@somewhere.redhat.com>
	<20120531153153.GH13591@infradead.org>
Date: Fri, 01 Jun 2012 11:48:05 +0900
In-Reply-To: <20120531153153.GH13591@infradead.org> (Arnaldo Carvalho de
	Melo's message of "Thu, 31 May 2012 12:31:53 -0300")
Message-ID: <87d35jn3x6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

On Thu, 31 May 2012 12:31:53 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, May 31, 2012 at 05:22:45PM +0200, Frederic Weisbecker escreveu:
>> On Thu, May 31, 2012 at 12:13:56PM -0300, Arnaldo Carvalho de Melo wrote:
>> > Em Thu, May 31, 2012 at 11:09:46AM -0400, Steven Rostedt escreveu:
>> > > On Thu, 2012-05-31 at 11:52 -0300, Arnaldo Carvalho de Melo wrote:
>> > > > Em Thu, May 31, 2012 at 03:07:26PM +0900, Namhyung Kim escreveu:
>> > > > > It'd be great if you set up a branch for this so that I can continue to
>> > > > > work on it until fully-merged.
>
>> > > > Have you had luck obtaining a git.kernel.org account? It would be better
>> > > > if you used git and maintained such branch :-\
>
>> > > Darn it! I wish I signed his key when I had the chance :-p
>
>> > I did it, Frédéric too, so he should have no problem getting an account,
>> > I think,
>> 
>> Except I haven't yet managed to get my korg account back and only Namhyung has
>> signed my key. So I'm not going to be very helpful in this regard ;)
>
> I just checked, he got other sigs, so your chain also should be good to
> go ;-)
>

After asking the account John said my key is outside of the trust path,
so I haven't had the luck. As I got additional sigs from Kukjin and
Tejun today, I think I'm inside now.

John, could you please process my account request?

Thanks,
Namhyung
