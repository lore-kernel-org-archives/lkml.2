Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1H3XPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 19:15:07 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43606 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1H3XPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 19:15:06 -0400
Message-ID: <4E5D6EF3.3000908@gmail.com>
Date: Wed, 31 Aug 2011 09:14:59 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: peter <lifulong2c2i2c@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question with "container_of(ptr, type, member)"
References: <1314701099.1728.6.camel@peter-2ci2c>
In-Reply-To: <1314701099.1728.6.camel@peter-2ci2c>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/11 20:44, peter wrote:
> I have a question about the macro " container_of(ptr, type, member) "
> I can write it as this,
>   #define container_of(ptr, type, member) ({ \
> 	(type *) ((char *) ptr - offset_of(type, member)); \
> 	})
> It can act the same as
> #define container_of(ptr, type, member) ({            \
> 	 const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
> 	 (type *)( (char *)__mptr - offsetof(type,member) );})
> So why we don't use the first one ?
> Thanks for your answer.
> (I am a kernel newbie ,and sorry for my poor english~)

The version used by the Linux kernel does type checking.

~Ryan

