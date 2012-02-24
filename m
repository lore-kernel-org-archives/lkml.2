Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab2BXTDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:03:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60633 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab2BXTDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:03:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of luto@amacapital.net designates 10.220.156.204 as permitted sender) smtp.mail=luto@amacapital.net
MIME-Version: 1.0
In-Reply-To: <4F471344.1010002@zytor.com>
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com>
 <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com>
 <20120215110122.GA3136@amit.redhat.com> <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com>
 <4F3D2C09.1020803@redhat.com> <CALCETrUhGY8C8JLz6DrbBxukV58K=2jrMSfDyAm=eF7OWbKx7g@mail.gmail.com>
 <4F3D395B.1000708@redhat.com> <CALCETrXjJtKLhe2rRkuy57Ai+5X2-+qh9eMbE5y-UhX=CPWftA@mail.gmail.com>
 <4F3D3F59.80807@redhat.com> <4F471344.1010002@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 24 Feb 2012 10:58:31 -0800
Message-ID: <CALCETrVk=3D0q2FHLhfZGhv4apFsJ1jnZAUWgwjRoFxT7OqPgQ@mail.gmail.com>
Subject: Re: [KVM paravirt issue?] Re: vsyscall=emulate regression
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 8:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/16/2012 09:39 AM, Avi Kivity wrote:
>>>
>>> Yes, this is on purpose
>
> Why?

I think the "this" refers to the PF_INSTR fault when executing at
0xffffffffff600xxx.  That's definitely intentional -- it's how
vsyscall emulation works.

I think it's unintentional that some kvm versions apparently forget to
set the PF_INSTR bit.

--Andy

>
>        -hpa
>
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
Office: (310) 553-5322
Mobile: (650) 906-0647
