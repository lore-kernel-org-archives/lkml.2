Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab2HBOQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:16:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52184 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab2HBOQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:16:22 -0400
Message-ID: <501A8BD0.1000603@gmail.com>
Date: Thu, 02 Aug 2012 16:16:48 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tasklist_lock lockdep warnings on 3.6
References: <500F954B.4010206@gmail.com> <CA+1xoqc86YFLOdBKPGjsb_moxjSdwoT_2Z6in8Co5YtEfKgNfw@mail.gmail.com> <20120802132605.GA27474@redhat.com>
In-Reply-To: <20120802132605.GA27474@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 03:26 PM, Dave Jones wrote:
> On Mon, Jul 30, 2012 at 04:50:46PM +0200, Sasha Levin wrote:
>  > ping?
>  > 
>  > I'm still seeing this on linux-next.
> 
> Likewise, except I'm seeing it in Linus' tree since shortly after this merge window
> began. (https://lkml.org/lkml/2012/7/24/443).
> 
> I've spent all of this last week doing multiple attempts at bisecting this without success.
> (It doesn't always show up, and even after running the test for over an hour before
> marking a build 'good')
> 
> Anyone ?
> 
> 	Dave

I've been able to hit this issue pretty much every time by hitting sysrq-t after about 10 seconds of fuzzing. It shows up in the middle of the sysrq-t spew.

Unfortunately I didn't have time yet to try and bisect it.
