Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0FIFcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:32:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38401 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab0FIFcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=si2blveVSEs5vrd6u2fYJfsh3248GzyJrzlqVR7l/kXr5QKyOvjuMiAqEHMaQzgF32
         rmvsltRvb5zNXpk5mTw+8M5uJ8+eZ1laiMF4qo/B9IG3Vjag/XxGuljiCiEcMmoyHn50
         DYw8QAPiDPDs/0tTdWHqz9ntHZPjooZOV5uxU=
MIME-Version: 1.0
In-Reply-To: <1276051329.13426.48.camel@localhost.localdomain>
References: <AANLkTik0UvRGmGeZOMaJVaoHk-lv2V8umAF3EIckh9CT@mail.gmail.com>
	<1276051329.13426.48.camel@localhost.localdomain>
Date: Wed, 9 Jun 2010 13:32:11 +0800
Message-ID: <AANLkTikSaMcKPh5GI3Tq2SZkVXsNKwE8pfR8me5IHDDv@mail.gmail.com>
Subject: Re: When and how to use ftrace?
From: Ryan Wang <openspace.wang@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/9 Steven Rostedt <srostedt@redhat.com>:
> On Wed, 2010-06-09 at 09:38 +0800, Ryan Wang wrote:
>> Hi all,
>>
>>        I'm new to kernel development, and I'm learning
>> ftrace recently. I have one question:
>>        When to use ftrace, or in which cases ftrace can be
>> more efficient?
>
> I can't really answer these questions without knowing what you want to
> do?
>
> ftrace allows you to see what is happening inside the kernel. What would
> you like to see?
>
> -- Steve
>
>
>

I really want to know is the differences between ftrace and other kernel debug
tools such as kdump, kdb, etc.

thanks!
