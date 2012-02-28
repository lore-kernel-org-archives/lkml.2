Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2B1KAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:00:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2B1KAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:00:53 -0500
Message-ID: <4F4CA5C2.4050605@redhat.com>
Date: Tue, 28 Feb 2012 12:00:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Amit Shah <amit.shah@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Subject: Re: [KVM paravirt issue?] Re: vsyscall=emulate regression
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com> <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com> <20120215110122.GA3136@amit.redhat.com> <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com> <4F3D2C09.1020803@redhat.com> <CALCETrUhGY8C8JLz6DrbBxukV58K=2jrMSfDyAm=eF7OWbKx7g@mail.gmail.com> <4F3D395B.1000708@redhat.com> <CALCETrXjJtKLhe2rRkuy57Ai+5X2-+qh9eMbE5y-UhX=CPWftA@mail.gmail.com> <4F3D3F59.80807@redhat.com> <4F471344.1010002@zytor.com> <CALCETrVk=3D0q2FHLhfZGhv4apFsJ1jnZAUWgwjRoFxT7OqPgQ@mail.gmail.com>
In-Reply-To: <CALCETrVk=3D0q2FHLhfZGhv4apFsJ1jnZAUWgwjRoFxT7OqPgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 08:58 PM, Andy Lutomirski wrote:
> On Thu, Feb 23, 2012 at 8:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 02/16/2012 09:39 AM, Avi Kivity wrote:
> >>>
> >>> Yes, this is on purpose
> >
> > Why?
>
> I think the "this" refers to the PF_INSTR fault when executing at
> 0xffffffffff600xxx.  That's definitely intentional -- it's how
> vsyscall emulation works.
>
> I think it's unintentional that some kvm versions apparently forget to
> set the PF_INSTR bit.
>

Correct.  Can you provide the version that failed, so we can fix it?

-- 
error compiling committee.c: too many arguments to function

