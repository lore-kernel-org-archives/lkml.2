Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab2CHWOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:14:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61453 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750Ab2CHWOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:14:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120308221252.GQ21812@moon>
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
	<20120308221252.GQ21812@moon>
Date: Thu, 8 Mar 2012 14:14:29 -0800
X-Google-Sender-Auth: hep4h1In4lbYAMotF1FfAzaoU70
Message-ID: <CAGXu5jJEWvBwuyFeNMgNQbXBop60kcGOgpYoWL+dmpZBPqjoCA@mail.gmail.com>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 2:12 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Thu, Mar 08, 2012 at 02:03:13PM -0800, Kees Cook wrote:
>>
>> How about "file_is_exec" instead, since it doesn't (and likely
>> shouldn't) include the inode_permission(..., EXEC)? I'd like other
>> people's thoughts on this since maybe it's not needed and I instead
>> have accidentally derailed this patch with useless bike shedding.
>>
>
> Yup. Anyway, I'm leaving the former mm_struct::exe_file patch with
> EXEC test opencoded so we can do everything on top then.

Sounds good to me. Thanks for putting up with my distraction! :)

-Kees

-- 
Kees Cook
ChromeOS Security
