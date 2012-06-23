Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2FWESe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:18:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47493 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2FWESa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:18:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120623040633.GA16278@kroah.com>
References: <CAN_1RdvqJRig8vZW_gcvNVKYNo7ROmEKxAs7qu1N6XE4+Pspjg@mail.gmail.com>
	<20120623040633.GA16278@kroah.com>
Date: Sat, 23 Jun 2012 12:18:29 +0800
Message-ID: <CAN_1RdtfiWtuqV=vBkagZfmvstket499QdCK3zZrrS8xKTZwPA@mail.gmail.com>
Subject: Re: [PATCH] Implement uhook(call kernel func from userspace) driver
From: Peiyong Feng <peiyong.feng.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/23 Greg KH <gregkh@linuxfoundation.org>:
> On Sat, Jun 23, 2012 at 11:20:35AM +0800, Peiyong Feng wrote:
>> Hi all,
>>
>> This patch implement the uhook kernel driver. Here are some ideals and
>> explanations:
>>
>> 1. What is uhook
>>
>> uhook(userspace kernel hook) means call kernel function from
>> userspace. That is to say, we can
>>
>> write a function in kernel space and call it in userspace while the
>> kernel Image is running. For example:
>
> That's, um, "interesting", but is of course, nothing we can accept into
> the main kernel tree, as I'm sure you can understand.  Otherwise, you
> just created a few thousand undocumented system calls whose behavior
> changes every release which is not something we can accept.
>
> But it is a great hack, very nicely done.  I'm sure that some people
> will like it for debugging, although I'm not quite sure you got all of

Well, is there some other tree I can commit the patch?
> the user/kernel boundry conditions correct, and I know the 32/64bit
> issues aren't handled, which you might want to clean up sometime in the

I am still working on it. The ultimate aim is that the uhook module can process
any funciton and any data type
> future.
>
> greg k-h
