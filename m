Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1HaAwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 20:52:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48565 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1HaAwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 20:52:36 -0400
Subject: Re: Question with "container_of(ptr, type, member)"
From: peter <lifulong2c2i2c@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4E5D6EF3.3000908@gmail.com>
References: <1314701099.1728.6.camel@peter-2ci2c>
	 <4E5D6EF3.3000908@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 08:52:20 +0800
Message-ID: <1314751940.1593.2.camel@peter-2ci2c>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see now, It can gives an waring:  "warning: initialization from
incompatible pointer type", when give it an wrong type.
thanks for your answer!
On Wed, 2011-08-31 at 09:14 +1000, Ryan Mallon wrote:
> On 30/08/11 20:44, peter wrote:
> > I have a question about the macro " container_of(ptr, type, member) "
> > I can write it as this,
> >   #define container_of(ptr, type, member) ({ \
> > 	(type *) ((char *) ptr - offset_of(type, member)); \
> > 	})
> > It can act the same as
> > #define container_of(ptr, type, member) ({            \
> > 	 const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
> > 	 (type *)( (char *)__mptr - offsetof(type,member) );})
> > So why we don't use the first one ?
> > Thanks for your answer.
> > (I am a kernel newbie ,and sorry for my poor english~)
> 
> The version used by the Linux kernel does type checking.
> 
> ~Ryan
> 


