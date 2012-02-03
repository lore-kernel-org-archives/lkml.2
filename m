Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2BCUTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:19:46 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50240 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2BCUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:19:44 -0500
Date: Fri, 3 Feb 2012 12:19:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew MacLeod <amacleod@redhat.com>, Torvald Riegel <triegel@redhat.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, dsterba@suse.cz, ptesarik@suse.cz,
        rguenther@suse.de, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
Message-ID: <20120203201911.GL2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFx4SdtZcYaWZ-=JG3yVFJxsBa-Yqn0m+h4Y=QHdRjx6_w@mail.gmail.com>
 <20120201224554.GK2382@linux.vnet.ibm.com>
 <CA+55aFyzYO0CMZOgdrVV0PdG2DkbwTQG7eE7N3bp=0tQmruFEQ@mail.gmail.com>
 <20120202184209.GD2518@linux.vnet.ibm.com>
 <CA+55aFyYxzED4OoYvb3nbET7_zyP5mGhEa2w_QCvQOx55bVjHg@mail.gmail.com>
 <20120202193747.GG2518@linux.vnet.ibm.com>
 <4F2C0D8A.70103@redhat.com>
 <CA+55aFx1NjR9XMQ9iLyVk05Erwtqgf7hfZkBCMJzkCMFJS8CHw@mail.gmail.com>
 <4F2C329B.2080107@redhat.com>
 <CA+55aFxoW0zexd4Zy33gToK9V0UU6wbQFFogEyFPPiGuNq2GGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxoW0zexd4Zy33gToK9V0UU6wbQFFogEyFPPiGuNq2GGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020320-3270-0000-0000-000003B7C381
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 12:00:03PM -0800, Linus Torvalds wrote:
> On Fri, Feb 3, 2012 at 11:16 AM, Andrew MacLeod <amacleod@redhat.com> wrote:

[ . . . ]

> Having access to __ATOMIC_ACQUIRE would actually be an improvement -
> it's just that the architectures that really care about things like
> that simply don't matter enough for us to really worry about them
> (ia64 being the prime example), and everybody else either doesn't need
> extra barriers at all (x86), or might as well use a full barrier (most
> everything else).

I believe that version 8 of the ARM architecture will provide load-acquire
and store-release instructions.

							Thanx, Paul

