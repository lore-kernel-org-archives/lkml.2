Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2HaQhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:37:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56419 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab2HaQhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:37:38 -0400
References: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com> <65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com> <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com> <4F5EDE5B.7070207@zytor.com> <1346428774.2864.16.camel@lorien2>
User-Agent: K-9 Mail for Android
In-Reply-To: <1346428774.2864.16.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: crash dump memory reservation regression
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 31 Aug 2012 09:37:05 -0700
To: shuah.khan@hp.com
CC: Yinghai Lu <yinghai@kernel.org>, CAI Qian <caiqian@redhat.com>,
        Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Message-ID: <0809406a-1043-47c8-b271-9ddb2ce35dba@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel Summit is this week... people are away.

Shuah Khan <shuah.khan@hp.com> wrote:

>On Mon, 2012-03-12 at 22:42 -0700, H. Peter Anvin wrote:
>> On 03/12/2012 10:31 PM, Yinghai Lu wrote:
>> > 
>> > Solution will be:
>> > 1.  remove the good_end setting for 64 bit again. and root cause S4
>resume.
>> 
>> This would by far be the best.
>> 
>> 	-hpa
>> 
>
>Any resolution on this issue. Has this been fixed? I haven't seen this
>message on the systems I am running the upstream kernel on, and would
>like to get a commit ID (if any) that fixed the problem.
>
>Thanks,
>-- Shuah

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
