Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab0KSAmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:42:14 -0500
Received: from solo.fdn.fr ([80.67.169.19]:41216 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247Ab0KSAmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:42:12 -0500
Date: Fri, 19 Nov 2010 01:42:10 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101119004210.GK6024@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
References: <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net> <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net> <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com> <20101116170312.GA19327@tango.0pointer.de> <1289930934.2109.644.camel@laptop> <20101116200546.GB27235@tango.0pointer.de> <4CE5C66F.3050300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CE5C66F.3050300@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, le Thu 18 Nov 2010 16:35:59 -0800, a écrit :
> On 11/16/2010 12:05 PM, Lennart Poettering wrote:
> > On Tue, 16.11.10 19:08, Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > 
> >>
> >> On Tue, 2010-11-16 at 18:03 +0100, Lennart Poettering wrote:
> >>> Binding something like this to TTYs is just backwards. No graphical
> >>> session has a TTY attached anymore. And there might be multiple TTYs
> >>> used in the same session. 
> >>
> >> Using a group per tty makes sense for us console jockeys..
> > 
> > Well, then maybe you shouldn't claim this was relevant for anybody but
> > yourself. Because it is irrelevant for most users if it is bound to the TTY.
> > 
> 
> For what it's worth, I suspect that the object that should be bound to
> is probably not the tty, but rather the session ID of the process (which
> generally is 1:1 with controlling TTY for console processes.)

Agreed.

That'll catch both the tty case (implemented by the proposed patch), and
the rest.

Samuel
