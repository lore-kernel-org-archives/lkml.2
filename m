Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2HaP7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 11:59:38 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2401 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2HaP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 11:59:37 -0400
Message-ID: <1346428774.2864.16.camel@lorien2>
Subject: Re: crash dump memory reservation regression
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, CAI Qian <caiqian@redhat.com>,
        Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 31 Aug 2012 09:59:34 -0600
In-Reply-To: <4F5EDE5B.7070207@zytor.com>
References: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com>
	 <65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com>
	 <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
	 <4F5EDE5B.7070207@zytor.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 22:42 -0700, H. Peter Anvin wrote:
> On 03/12/2012 10:31 PM, Yinghai Lu wrote:
> > 
> > Solution will be:
> > 1.  remove the good_end setting for 64 bit again. and root cause S4 resume.
> 
> This would by far be the best.
> 
> 	-hpa
> 

Any resolution on this issue. Has this been fixed? I haven't seen this
message on the systems I am running the upstream kernel on, and would
like to get a commit ID (if any) that fixed the problem.

Thanks,
-- Shuah


