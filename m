Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab2CHWNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:13:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53393 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab2CHWNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:13:06 -0500
Date: Fri, 9 Mar 2012 02:12:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308221252.GQ21812@moon>
References: <20120308165112.GF21812@moon>
 <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
 <20120308194008.GJ21812@moon>
 <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
 <20120308200729.GL21812@moon>
 <CALCETrXc9Etit+DUuxKtUwRKmqbwbE5vhDNYWgs0ijEesY8cUA@mail.gmail.com>
 <20120308202136.GM21812@moon>
 <CALCETrVe6VQgdEkZBv24ZaS-N8bFLr9umhgmBsHB6CMH699ykA@mail.gmail.com>
 <20120308215731.GP21812@moon>
 <CAGXu5j+fDwk_17bLtx9KdeoCs+hxgksMvxzutJjgB76tP+NV4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+fDwk_17bLtx9KdeoCs+hxgksMvxzutJjgB76tP+NV4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 02:03:13PM -0800, Kees Cook wrote:
> 
> How about "file_is_exec" instead, since it doesn't (and likely
> shouldn't) include the inode_permission(..., EXEC)? I'd like other
> people's thoughts on this since maybe it's not needed and I instead
> have accidentally derailed this patch with useless bike shedding.
> 

Yup. Anyway, I'm leaving the former mm_struct::exe_file patch with
EXEC test opencoded so we can do everything on top then.

	Cyrill
