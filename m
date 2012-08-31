Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2HaQub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:50:31 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:4233 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2HaQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:50:29 -0400
Message-ID: <1346431827.2864.31.camel@lorien2>
Subject: Re: crash dump memory reservation regression
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Takashi Iwai <tiwai@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        CAI Qian <caiqian@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org, shuah.khan@hp.com, shuahkhan@gmail.com
Date: Fri, 31 Aug 2012 10:50:27 -0600
In-Reply-To: <s5hmx1b3teh.wl%tiwai@suse.de>
References: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com>
	 <65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com>
	 <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
	 <4F5EDE5B.7070207@zytor.com> <1346428774.2864.16.camel@lorien2>
	 <0809406a-1043-47c8-b271-9ddb2ce35dba@email.android.com>
	 <s5hmx1b3teh.wl%tiwai@suse.de>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-31 at 18:42 +0200, Takashi Iwai wrote:
> At Fri, 31 Aug 2012 09:37:05 -0700,
> H. Peter Anvin wrote:
> > 
> > Kernel Summit is this week... people are away.
> 
> I (as a person who asked the revert) don't mind now to set the
> good_end back for 64bit again.  On 3.5/3.6 kernels, there seems more
> other places breaking the hibernation on the machines hitting the
> problem at that time.  I need to dig deeply, but it's a horrible time-
> consuming and unreliable task, thus postponed, so far.
> 

I can work on getting this change in, if you are short on time. I am
seeing this on a few systems and would like to resolve it before 3.6
window closes.

Thanks,
-- Shuah

