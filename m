Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab0LZHEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 02:04:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63996 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0LZHEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 02:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NsEYKaAmZMKLGUqojPvD0Iu/+mLAvmC4GREuUtK5PhQDDkz21S4YWTEKiZZmM5cWjX
         LVhvHzYPMZa1rUtSB2KZW3QxRw0BArRR0f57TNQl7vPLxkAGG2L8P8qtDK0p1py3ixWe
         UrJ/JoquQkPc2+DHqOaPgOZ/k0onf6ZJihEcc=
MIME-Version: 1.0
In-Reply-To: <AANLkTi==ahwQXGK-hPq+2KVRRwQiL9j7vVakAwi=NTiq@mail.gmail.com>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<AANLkTi==ahwQXGK-hPq+2KVRRwQiL9j7vVakAwi=NTiq@mail.gmail.com>
Date: Sun, 26 Dec 2010 15:04:21 +0800
Message-ID: <AANLkTinye4NY6D=pHWRKTW=smhS3qg1kfBW7wncQgXSU@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 2:46 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Sun, Dec 26, 2010 at 11:13 AM, Hillf Danton <dhillf@gmail.com> wrote:
>> Based upon high resolution timer and idea borrowed from semaphore,
>> nano semaphore is created.
>>
>> Nano semaphore provides finer time resolution depending on system
>> configuration and capabilities.
>>
>> Nano semaphore is not to replace semaphore, but used in application
>> environments where nano seconds are required.
>>
>> Three methods, nano_semaphore_try_down, nano_semaphore_down and
>> nano_semaphore_up are implemented in a header file, and there is no
>> corresponding C file since nano semaphore is not complex.
>>
>
> Above description tells how its done, what it is but its not clear why
> we should use it. Can I know why should we use it or its benefits?
>

The outstanding benefit looks that nano semaphore could be used in
cases where callers want to wait not only more than one jiffy, but far
less than one jiffy also.

thanks
Hillf

>
> thanks,
> rakib
