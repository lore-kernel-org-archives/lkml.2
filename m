Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877Ab2JYCql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:46:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48655 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab2JYCqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <20121025024357.GA24008@kroah.com>
References: <20121022195250.GD8567@kroah.com>
	<1351131793-6611-1-git-send-email-yamanetoshi@gmail.com>
	<20121025024357.GA24008@kroah.com>
Date: Thu, 25 Oct 2012 11:46:39 +0900
Message-ID: <CAOTypNRFVSRumBErjrN4s1_oy5yg4o00NkiJXnScXgpcq0EeJQ@mail.gmail.com>
Subject: Re: [PATCH v2] staging/comedi: Use pr_ or dev_ printks in drivers/gsc_hdpi.c
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:43 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Oct 25, 2012 at 11:23:13AM +0900, YAMANE Toshiaki wrote:
>> fixed below checkpatch warning.
>> - WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
>>
>> some of them have been replaced by dev_dbg or pr_debug,
>> and added pr_fmt.
>>
>> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
>
> This patch doesn't apply, can you redo it against the next linux-next
> release and resend it?

Yes, thanks.


-- 

Regards,

YAMANE Toshiaki
