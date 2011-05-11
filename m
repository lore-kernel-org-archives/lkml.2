Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1EKQD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:03:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63797 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab1EKQDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x+sqsBoz0sk6WAU1V0g2PFYKfk0822yRfNm3H5Qb85maPpDjTyWSlWDSNG/2tTEToQ
         mYTGEr19GwPTh6Qg4kUK0rl+9cCFb2LjX7ieuMClB+2pftfv01Xtw6XrfgHZ/IR/wLUI
         gpmTgpBG97KoJ3xrM8o7PjC2endqTN5mSUo4k=
MIME-Version: 1.0
In-Reply-To: <20110511141509.GB19053@elte.hu>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
	<1305016329.2914.22.camel@laptop>
	<BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
	<1305122055.2914.220.camel@laptop>
	<BANLkTikShtNvCcz5hfm5kgUwBwS1LqF9xg@mail.gmail.com>
	<20110511141509.GB19053@elte.hu>
Date: Wed, 11 May 2011 22:23:37 +0800
Message-ID: <BANLkTimGXAAdeKNvncghT6PF+Vko9SWVnA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
From: Hillf Danton <dhillf@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Here's how you fetch the scheduler tree:
>
>  http://people.redhat.com/mingo/tip.git/README
>
> and here's the Kernel Hacker's Guide to Git:
>
>  http://linux.yyz.us/git-howto.html
>

Thank you, Ingo, very much for guiding git and scheduler tree.

I will try git clone the scheduler tree this weekend.

Thanks,
            Hillf
