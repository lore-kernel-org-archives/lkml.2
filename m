Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2EFRhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:37:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34710 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab2EFRhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:37:40 -0400
Message-ID: <4FA6B6DB.5050904@zytor.com>
Date: Sun, 06 May 2012 10:37:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
References: <20120506162000.GT6871@ZenIV.linux.org.uk> <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com>
In-Reply-To: <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2012 10:16 AM, Linus Torvalds wrote:
> On Sun, May 6, 2012 at 9:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> Setting TIF_IA32 in load_aout_binary() used to be enough; these days
>> TASK_SIZE is controlled by TIF_ADDR32 and that one doesn't get set
>> there.  Switch to use of set_personality_ia32()...
> 
> Applied. Just out of curiosity, how did you notice? Just looking at
> TIF_IA32 usage, or do you actually have some old app?
> 

OK, I just queued it up in my tree for a push to you... do you want me
to drop it back out and send the balance?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

