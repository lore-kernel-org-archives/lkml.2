Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1GZBUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:20:04 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60779 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GZBT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <1311642766.3526.60.camel@gandalf.stny.rr.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1311618747.3526.32.camel@gandalf.stny.rr.com>
	<CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	<1311625197.3526.35.camel@gandalf.stny.rr.com>
	<CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	<CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
	<mcrfwltoov5.fsf@coign.corp.google.com>
	<CACqU3MXuMDz46rM9p_7iBeK1G0T-DH=52KHj9ygc42j=qQmP4g@mail.gmail.com>
	<1311642766.3526.60.camel@gandalf.stny.rr.com>
Date: Mon, 25 Jul 2011 21:19:57 -0400
Message-ID: <CACqU3MXysWUYNnNQniR5LB4x1UGhJqwoYnTFmj=U8do-qRghow@mail.gmail.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Arnaud Lacombe <lacombar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ian Lance Taylor <iant@google.com>, gcc-help@gcc.gnu.org,
        stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 25, 2011 at 9:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-07-25 at 21:08 -0400, Arnaud Lacombe wrote:
>> Hi,
>>
>
>> but the code generated seem to test %esi (`b', potentially
>> uninitialized) before %ebx (`a'). Am I still missing something ?
>
> But it tests 'a' again afterward. If 'a' is 0, it doesn't matter what
> 'b' was. So the uninitialized test is a wash. No harm done, except for
> some wasted CPU cycles.
>
I see, even if `b' is junk, the final logic does not change.

 - Arnaud
