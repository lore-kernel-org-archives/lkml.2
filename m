Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0K0T1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 14:27:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38267 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0K0T1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 14:27:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C5lw58eriOlzK/rw8yDKq7wt5Yu2VMTKAXQhABQYC6imxaxCfx6eZPTTRZYdf8drE7
         HWw/L3k7gi8fC4HPRkFAjiuIvOE45MpOg6hlrbGRU3CJQTd2hfBaq0ooYQFXfGLuOvjy
         I9MIec5zYlz+rHyEFxnErog7A4CQpfku2/+4M=
MIME-Version: 1.0
In-Reply-To: <874ob2r3w0.fsf@gmail.com>
References: <201011271821.35039.jason.vas.dias@gmail.com>
	<874ob2r3w0.fsf@gmail.com>
Date: Sat, 27 Nov 2010 16:27:36 -0300
Message-ID: <AANLkTin=BMcfmm_0p=OVwN6FYUfp6nUuT85uKZnqHGE8@mail.gmail.com>
Subject: Re: per-chroot clock module ?
From: Elias Gabriel Amaral da Silva <tolkiendili@gmail.com>
To: Ben Gamari <bgamari@gmail.com>
Cc: jason.vas.dias@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/27 Ben Gamari <bgamari@gmail.com>:
> On Sat, 27 Nov 2010 18:21:34 +0000, Jason Vas Dias <jason.vas.dias@gmail.com> wrote:
>> Greetings -
>>
>> Sorry in advance if this is a stupid idea, but -
>>
>> I'd really like to be able to set a distinct "clock" for a specific chroot environment,
>> such that the super-user could call :
>> [snip]
>
> It certainly doesn't sound like a particularly good idea to me. This
> would add great complexity to the kernel while having very few
> users. Perhaps there's something I haven't considered but I can't think
> of any good applications for this sort of functionality. Do you have
> something in particular in mind?
>
> It seems like what you want here is simple virtualization. Have you
> considered KVM? The closest thing to your request currently upstream is
> containers, although I'm unsure of whether a container can be created
> with an independent clock. Might be something to look into.

KVM needs hardware support (but chroot runs wherever Linux runs)
