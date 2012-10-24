Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab2JXBHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 21:07:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46500 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806Ab2JXBHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 21:07:36 -0400
Date: Tue, 23 Oct 2012 21:07:32 -0400 (EDT)
Message-Id: <20121023.210732.310456458676293536.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 098/193] drivers/net/usb: remove CONFIG_EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGXu5jLsEJgQbriHRNNAuwpbf3TEEG-zoctS0Vj0k3R6u0rUZg@mail.gmail.com>
References: <1351022666-6960-99-git-send-email-keescook@chromium.org>
	<20121023201522.GC3408@kroah.com>
	<CAGXu5jLsEJgQbriHRNNAuwpbf3TEEG-zoctS0Vj0k3R6u0rUZg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 23 Oct 2012 15:53:27 -0700

> On Tue, Oct 23, 2012 at 1:15 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Tue, Oct 23, 2012 at 01:02:51PM -0700, Kees Cook wrote:
>>> This config item has not carried much meaning for a while now and is
>>> almost always enabled by default. As agreed during the Linux kernel
>>> summit, remove it.
>>>
>>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  drivers/net/usb/Kconfig |   16 +++++++---------
>>>  1 file changed, 7 insertions(+), 9 deletions(-)
>>
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> But note, drivers/net/usb/ is handled by netdev@, not by me, so I can't
>> take this, sorry.
> 
> Sounds good. David, do you want me to carry this with the others?

Yes.
