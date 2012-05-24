Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab2EXPyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:54:10 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36220 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab2EXPyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyriUQCdEpa_YPBk-JvKAN26xC=MxWb3kO=xSkEou27dA@mail.gmail.com>
References: <20120523113432.GA12142@gmail.com>
	<CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
	<4FBD1AC8.7020602@zytor.com>
	<20120523174844.GA3373@gmail.com>
	<CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
	<4FBE5456.5020408@zytor.com>
	<CA+55aFyriUQCdEpa_YPBk-JvKAN26xC=MxWb3kO=xSkEou27dA@mail.gmail.com>
Date: Thu, 24 May 2012 23:54:07 +0800
Message-ID: <CANQmPXgxT3rvgGCOjztuGCTkgf4aa2-5a5q6K-8xPR1EcAsdgA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
From: Chen <hi3766691@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, May 24, 2012 at 8:31 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Just for clarification - do you want the patch reverted?  My reading of
>> what you wrote (as well as of the patch) is that it was an unnecessary
>> (redundant) patch, but Ingo is worried that you are saying it is incorrect.
>
> It's not technically incorrect, it was just unnecessary.
>
>                   Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Everyone knows that this patch had been unstable. Also, too much code
are pushed into printk() with the patch
