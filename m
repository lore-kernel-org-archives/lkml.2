Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2JJUIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:08:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53328 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2JJUIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:08:20 -0400
Date: Wed, 10 Oct 2012 16:08:16 -0400 (EDT)
Message-Id: <20121010.160816.1174547411763490557.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: dhowells@redhat.com, socketcan@hartkopp.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for can
From: David Miller <davem@davemloft.net>
In-Reply-To: <5075D2AF.1010409@pengutronix.de>
References: <30687.1349789402@warthog.procyon.org.uk>
	<27643.1349892024@warthog.procyon.org.uk>
	<5075D2AF.1010409@pengutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 10 Oct 2012 21:55:27 +0200

> On 10/10/2012 08:00 PM, David Howells wrote:
>> Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>> 
>>> On 10/09/2012 03:30 PM, David Howells wrote:
>>>> Can you merge the following branch into the can tree please.
>>>>
>>>> This is to complete part of the Userspace API (UAPI) disintegration for which
>>>> the preparatory patches were pulled recently.  After these patches, userspace
>>>> headers will be segregated into:
>>>>
>>>> 	include/uapi/linux/.../foo.h
>>>>
>>>> for the userspace interface stuff, and:
>>>>
>>>> 	include/linux/.../foo.h
>>>>
>>>> for the strictly kernel internal stuff.
>>>
>>> Nice work David. The upstream for can-next is David Miller's net-next
>>> tree. He doesn't like if I pull unrelated stuff into my tree, so I'm
>>> going to cherry pick your patch. This is not yet possible, as net-next
>>> doesn't include the latest patches from the 3.7 merge window, so that
>>> compilation breaks. After the merge window closes David Miller merges
>>> back the latest changes to net-next. I'll postpone your patch until
>>> then, this means the code will go into v3.8. I'm not familiar with the
>>> UAPI conversion, should your patch go via linux-can and David's net into
>>> v3.7?
>> 
>> It's okay for the patch to go into 3.8 if that is easier for you.  As it's
>> scripted, I can regenerate your branch after -rc1 if that helps too.
> 
> I don't mind, as long as it compiles (using you tag), and it does, the
> patch doesn't break anything. From the linux-can and David Miller's net
> point of view, v3.7 is closed for new features just bug fixes are
> allowed. But I'm open to make an exception, if UAPI hits mainline in
> v3.7 on most subsystems. Hopefully David sees it the same way.

We're putting the UAPI stuff in now, don't delay this please.
