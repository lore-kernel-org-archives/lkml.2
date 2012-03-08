Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2CHU2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:28:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49739 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab2CHU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:28:07 -0500
Date: Fri, 9 Mar 2012 00:28:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308202802.GN21812@moon>
References: <20120308165112.GF21812@moon>
 <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
 <20120308194008.GJ21812@moon>
 <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
 <20120308200729.GL21812@moon>
 <CALCETrXc9Etit+DUuxKtUwRKmqbwbE5vhDNYWgs0ijEesY8cUA@mail.gmail.com>
 <20120308202136.GM21812@moon>
 <CALCETrVe6VQgdEkZBv24ZaS-N8bFLr9umhgmBsHB6CMH699ykA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVe6VQgdEkZBv24ZaS-N8bFLr9umhgmBsHB6CMH699ykA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 12:24:38PM -0800, Andy Lutomirski wrote:
...
> >
> > I've been in To: field that's why I replied you about nnp
> > (and, btw, what nnp is? not "Net national product" I suppose,
> >  this hint wikipedia gave me)
> 
> nnp is no_new_privs, which is my patch and is almost, but not quite,
> very relevant to this discussion.  Hence my confusion ;)

Ah, good to know (I'm on 3.3-rc6 now, so I've not yet noticed
this nnp helper :)

> 
> FWIW, since I've touched this code recently, the cleanup you're
> suggesting sounds good.

OK, once I prepare the helper we will see how it fits with
other code.

	Cyrill
