Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032301Ab2CSQzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:55:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43842 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032166Ab2CSQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:55:38 -0400
Date: Mon, 19 Mar 2012 20:55:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Andrew Vagin <avagin@openvz.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [patch 2/2] c/r: prctl: Add ability to get clear_tid_address
Message-ID: <20120319165534.GI19594@moon>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.993662395@openvz.org>
 <CAGXu5jJq5yQDadMpRasXNOV3=auRF5WbyyEf3bodf42veg9F0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJq5yQDadMpRasXNOV3=auRF5WbyyEf3bodf42veg9F0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 09:51:36AM -0700, Kees Cook wrote:
> On Fri, Mar 16, 2012 at 1:55 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > Zero is written at clear_tid_address, when
> > the process exits. This functionality is used
> > by pthread_join().
> >
> > We already have sys_set_tid_address() to change this
> > address for current task but there is no way to obtain
> > it from a user space.
> 
> Is it worth introducing a syscall for this just for symmetry? I
> suspect not, in which case:
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 

Thanks Kees! syscall was considered as "no-no" in previous
convesation about this patch, so we switched to prctl.

	Cyrill
