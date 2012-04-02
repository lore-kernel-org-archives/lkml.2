Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab2DBJ0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:26:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62681 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2DBJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:26:32 -0400
Date: Mon, 2 Apr 2012 13:26:27 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "drepper@gmail.com" <drepper@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120402092627.GC7607@moon>
References: <20120401125741.GA7484@p183.telecom.by>
 <4F785F1D.4020503@openvz.org>
 <20120402010937.38b33576@pyramind.ukuu.org.uk>
 <4F796581.1030302@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F796581.1030302@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 12:38:25PM +0400, Konstantin Khlebnikov wrote:
> Alan Cox wrote:
> >>Can we add "pid" argument to be able to search next fd in other task?
> >>Together with sys_kcmp() this will be very useful for checkpoint/restore.
> >
> >That would raise all sorts of security questions unless protected, plus
> >its got races. If you want to do that and you have the rights you can do
> >it via procfs anyway.
> 
> Don't worry, I just asked. =) Seems like crtools dumps fd in the target-task context,
> so the current version is suitable.

Kind of ;) At moment we drain fds from dumpee task context to
our tool context and then dump them.

	Cyrill
