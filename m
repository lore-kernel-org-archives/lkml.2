Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab2CHUVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:21:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52045 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab2CHUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:21:41 -0500
Date: Fri, 9 Mar 2012 00:21:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308202136.GM21812@moon>
References: <20120308165112.GF21812@moon>
 <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
 <20120308194008.GJ21812@moon>
 <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
 <20120308200729.GL21812@moon>
 <CALCETrXc9Etit+DUuxKtUwRKmqbwbE5vhDNYWgs0ijEesY8cUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrXc9Etit+DUuxKtUwRKmqbwbE5vhDNYWgs0ijEesY8cUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 12:15:55PM -0800, Andy Lutomirski wrote:
> On Thu, Mar 8, 2012 at 12:07 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > On Thu, Mar 08, 2012 at 12:02:50PM -0800, Andy Lutomirski wrote:
> >> >
> >> > I can do that if Andrew agree.
> >>
> >> I'm a bit lost.  nnp updates the MNT_NOSUID checks, not the MNT_NOEXEC
> >> checks.  (And the effects of the two flags is different in selinux for
> >> historical reasons.)  I'm sure I'm missing something.
> >>
> >
> > Andy, I've no idea what nnp is ;) I was only about to gather those
> > ISREG/MNT_NOEXEC to one helper since we indeed have a few places in
> > kernel which do same thing in open-coded manner.
> 
> Am I not the Andrew you were referring to?
> 

Nope, I meant Andrew Morton /because this patch is for -mm/ ;)

I've been in To: field that's why I replied you about nnp
(and, btw, what nnp is? not "Net national product" I suppose,
 this hint wikipedia gave me)

	Cyrill
