Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2EXPsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:48:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62343 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab2EXPsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <4FBE5456.5020408@zytor.com>
References: <20120523113432.GA12142@gmail.com>
	<CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
	<4FBD1AC8.7020602@zytor.com>
	<20120523174844.GA3373@gmail.com>
	<CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
	<4FBE5456.5020408@zytor.com>
Date: Thu, 24 May 2012 23:48:37 +0800
Message-ID: <CANQmPXj6oa_bFCS2tST8=GzanrFUnD7nKDROb04K-9iJC7tZQg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
From: Chen <hi3766691@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/23/2012 10:57 AM, Linus Torvalds wrote:
>> On Wed, May 23, 2012 at 10:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>> Also, we can rebase the whole branch and get rid of this one and
>>> of the merge commit it has.
>>
>> I took it, but it was really unnecessary.
>>
>> There were printk() patches in the queue and being discussed that
>> needed this, but I wouldn't have pulled the end result if they hadn't
>> been fixed.
>>
>
> Hi Linus,
>
> Just for clarification - do you want the patch reverted?  My reading of
> what you wrote (as well as of the patch) is that it was an unnecessary
> (redundant) patch, but Ingo is worried that you are saying it is incorrect.
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Really redundant.The author is just re-implement the same
things.(Seems he disnt know that this is already implement.)
