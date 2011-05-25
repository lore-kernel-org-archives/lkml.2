Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1EYPwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:52:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61172 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1EYPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LF8ZCHkjB6MFcL0J+6l6J+i3f1L4C8OgKsXVW0OaWB0p1SHMcfhx8W8eZ8YwObg3/2
         m9k16Ha/yyLB1TwzC+8xiLvunsTPahOIzjuAyP/qO7i1ixkQSVDTtdU9b+YN+4Ef3yT6
         y+6rZPD0GN4psUMP4mv+iGo0cFnPf+sHyAGAw=
MIME-Version: 1.0
In-Reply-To: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
References: <1306334551.2298.89.camel@Joe-Laptop>
	<BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
Date: Wed, 25 May 2011 18:52:08 +0300
Message-ID: <BANLkTinHMx_esp8miCb6XzJG=f-BF-84Hw@mail.gmail.com>
Subject: Re: [PATCH 1/4] include/linux/printk.h is not self-contained
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 6:20 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>> If not, maybe add:
>>
>> #ifndef _LINUX_KERNEL_H
>> #error don't include <linux/printk.h> directly, use <linux/kernel.h>
>> #endif
>
> That's another possibility. We already have several users, though.

Eh, it is because of sheer amount of printk() users headers aren't switched,
from kernel.h to printk.h
