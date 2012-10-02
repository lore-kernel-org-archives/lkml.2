Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2JBNba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:31:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42600 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2JBNb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:31:29 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121002132805.GA30187@kroah.com>
References: <87627b9453.fsf@intel.com>
	<1348336331-20957-1-git-send-email-daniel.vetter@ffwll.ch>
	<20120922200629.GC14004@kroah.com>
	<CAKMK7uGkocM2Kmy6mkLya1O+hCf9ZDMF_+aLsfe==0Lx0nQrsQ@mail.gmail.com>
	<20121002132805.GA30187@kroah.com>
Date: Tue, 2 Oct 2012 15:31:28 +0200
Message-ID: <CAKMK7uHDwoLbXCUbWyJr9NX7g0MN_8B=sV-6w=tYGWYk+GN4tg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] console: implement lockdep support for console_lock
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 3:28 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> No, as it hasn't been in linux-next already, I can't send it in for 3.7,
> sorry, you know that.  I'll be glad to queue it up for 3.8 if you want me to.

Hey, was worth a shot ;-) Yeah, if you can pick it up for 3.8, that
would be nice, since the patches have been floating for a while by now
...

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
