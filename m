Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1DZK2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:28:08 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60141 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab1DZK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:28:06 -0400
Date: Tue, 26 Apr 2011 11:28:04 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] signal: introduce do_sigtimedwait() to factor out
 compat/native code
Message-ID: <20110426112804.6bd0713b@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110423175940.GC484@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
	<20110418173224.GA27918@redhat.com>
	<BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
	<20110423175901.GA484@redhat.com>
	<20110423175940.GC484@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 19:59:40 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Factor out the common code in sys_rt_sigtimedwait/compat_sys_rt_sigtimedwait
> to the new helper, do_sigtimedwait().
> 
> Perhaps it would be better to move compat_sys_rt_sigtimedwait() into
> signal.c under CONFIG_COMPAT, then we can make do_sigtimedwait() static.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

The changes Tejun suggested seem like a good idea. I also think that
moving compat_sys_rt_sigtimedwait() into signal.c makes sense.

-- 
Matt Fleming, Intel Open Source Technology Center
