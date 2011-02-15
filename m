Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1BOTQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:16:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56762 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab1BOTQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:16:39 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinf_GiHFd56jkF4dyfaOEGY58OxRp8ohbO3Qiox@mail.gmail.com>
References: <20110212084814.22218.92022.stgit@localhost6.localdomain6> <AANLkTinf_GiHFd56jkF4dyfaOEGY58OxRp8ohbO3Qiox@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 15 Feb 2011 12:16:17 -0700
X-Google-Sender-Auth: wYIeCXUwMwPmEkV_P5ohB-0izg8
Message-ID: <AANLkTi=GL0KJPzxhc1GyxFf9Au+eDuNTHoHO9hU-FuMc@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add entry for GPIO subsystem
To: Josh Boyer <jwboyer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 7:20 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Sat, Feb 12, 2011 at 3:48 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> I'll probably regret this....
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
> You  might as well just do the below instead, given the number of
> subsystems you maintain and areas of focus you have. ;)

heh, I think you overstate my influence.

I won't put my name forward for this, but I won't object if the arch
and embedded maintainers think I should be added to this list.

g.

>
> josh
>
> ---
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 531c5cf..7773c8a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2409,6 +2409,7 @@ F:        drivers/net/ehea/
>
>  EMBEDDED LINUX
>  M:     Paul Gortmaker <paul.gortmaker@windriver.com>
> +M:     Grant Likely <grant.likely@secretlab.ca>
>  M:     Matt Mackall <mpm@selenic.com>
>  M:     David Woodhouse <dwmw2@infradead.org>
>  L:     linux-embedded@vger.kernel.org
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
