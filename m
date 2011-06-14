Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab1FNMzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:55:33 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64259 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1FNMza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ObrtgS8NS/QPCT54QoUG+UPBlkhOwM9+AZSpUV73JLzg5lzsYhUlR07fFFt9zK+5wr
         O6HzWX2MdlYa8gcx1f9RSel1EX6yW+ziptK1Ly7CwqRUFUTe6itGXzMvrwgE/l1mCODW
         T/3UkbD2QTS8QHwVl3vQYMUazNO1rEAu8symk=
MIME-Version: 1.0
In-Reply-To: <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
	<BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com>
Date: Tue, 14 Jun 2011 15:55:29 +0300
Message-ID: <BANLkTimR3RbcaG6DfVHH1SUz0upa4tEXCg@mail.gmail.com>
Subject: Re: Linux 3.0-rc3
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 3:15 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> I've got a patch for my project to fix parsing of kernel version which
> has only two numbers. Basically,

Why does your project care about kernel version?
