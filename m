Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159Ab2B1LIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:08:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2B1LIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:08:37 -0500
Date: Tue, 28 Feb 2012 16:38:23 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Subject: Re: [KVM paravirt issue?] Re: vsyscall=emulate regression
Message-ID: <20120228110823.GA9197@amit.redhat.com>
References: <20120215110122.GA3136@amit.redhat.com>
 <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com>
 <4F3D2C09.1020803@redhat.com>
 <CALCETrUhGY8C8JLz6DrbBxukV58K=2jrMSfDyAm=eF7OWbKx7g@mail.gmail.com>
 <4F3D395B.1000708@redhat.com>
 <CALCETrXjJtKLhe2rRkuy57Ai+5X2-+qh9eMbE5y-UhX=CPWftA@mail.gmail.com>
 <4F3D3F59.80807@redhat.com>
 <4F471344.1010002@zytor.com>
 <CALCETrVk=3D0q2FHLhfZGhv4apFsJ1jnZAUWgwjRoFxT7OqPgQ@mail.gmail.com>
 <4F4CA5C2.4050605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4CA5C2.4050605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 28 Feb 2012 [12:00:34], Avi Kivity wrote:
> On 02/24/2012 08:58 PM, Andy Lutomirski wrote:
> > On Thu, Feb 23, 2012 at 8:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > > On 02/16/2012 09:39 AM, Avi Kivity wrote:
> > >>>
> > >>> Yes, this is on purpose
> > >
> > > Why?
> >
> > I think the "this" refers to the PF_INSTR fault when executing at
> > 0xffffffffff600xxx.  That's definitely intentional -- it's how
> > vsyscall emulation works.
> >
> > I think it's unintentional that some kvm versions apparently forget to
> > set the PF_INSTR bit.
> >
> 
> Correct.  Can you provide the version that failed, so we can fix it?

I'm running this on a RHEL host, the version that fails is
2.6.32-220.4.1.el6.x86_64, but can't say when it got introduced,
haven't gone back and checked that.

		Amit
