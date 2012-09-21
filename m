Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab2IUUvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:51:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56194 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab2IUUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:51:35 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] input: Dynamic Minor Numbers
Date: Fri, 21 Sep 2012 13:51:30 -0700
Message-ID: <2737921.JXTsrgJ0N6@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.8.5 (Linux/3.6.0-rc6+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CANq1E4Rcj0UsgQr=0sohXn8rXpY92PMnHAYwXNpsPPFULHQsrw@mail.gmail.com>
References: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com> <CANq1E4Q-35oF11Dz6mbNvNYpWYSfOgCXW_E4ZwJ2neZB8p_64w@mail.gmail.com> <CANq1E4Rcj0UsgQr=0sohXn8rXpY92PMnHAYwXNpsPPFULHQsrw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 21, 2012 09:18:00 PM David Herrmann wrote:
> Hi Dmitry
> 
> On Fri, Sep 21, 2012 at 11:22 AM, David Herrmann
> 
> <dh.herrmann@googlemail.com> wrote:
> > Hi Dmitry
> > 
> > On Fri, Sep 21, 2012 at 10:07 AM, Dmitry Torokhov
> > 
> > <dmitry.torokhov@gmail.com> wrote:
> >> Thank you very much for working on this, unfortunately your patch extends
> >> the existing infrastructure handling of character devices in input core,
> >> which is quite rigid and sub-optimal.
> >> 
> >> For a while now I wanted to stop input core from pre-creating character
> >> devices and multiplexing file operations and instead push more chardev
> >> handling tasks into individual input handlers and make they more
> >> independent from input core. So while I won't be taking your patch as is
> >> it was a great motivator to finally do something about current
> >> limitation and I would appreciate if you could take a look at the patch
> >> below and see if you have any issues with it.
> > 
> > I didn't know why we did that, anyway. But I tried to keep that logic,
> > even though it is really weird. So I am quite glad that you fixed it.
> 
> Sorry, compiling a kernel takes 44m here so I haven't had time earlier
> this day. But I just recompiled with your patch and it works like a
> charm. I have attached output of "ls -la /dev/input" with 900 uinput
> devices. Performance does suck but that is definitely another issue.

Could you elaborate a bit on this?

> 
> So here's my:
> Tested-by: David Herrmann <dh.herrmann@googlemail.com>

Thanks for testing!

-- 
Dmitry
