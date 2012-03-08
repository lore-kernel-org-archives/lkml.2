Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2CHUHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:07:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54879 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab2CHUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:07:34 -0500
Date: Fri, 9 Mar 2012 00:07:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308200729.GL21812@moon>
References: <20120308165112.GF21812@moon>
 <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
 <20120308194008.GJ21812@moon>
 <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 12:02:50PM -0800, Andy Lutomirski wrote:
> >
> > I can do that if Andrew agree.
> 
> I'm a bit lost.  nnp updates the MNT_NOSUID checks, not the MNT_NOEXEC
> checks.  (And the effects of the two flags is different in selinux for
> historical reasons.)  I'm sure I'm missing something.
> 

Andy, I've no idea what nnp is ;) I was only about to gather those
ISREG/MNT_NOEXEC to one helper since we indeed have a few places in
kernel which do same thing in open-coded manner.

	Cyrill
