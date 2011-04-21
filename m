Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1DUUJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:09:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170Ab1DUUJg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:09:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110421195801.GA15126@redhat.com>
References: <20110421192117.GA14249@redhat.com> <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
 <4DB087EC.1010205@caviumnetworks.com> <1303415086.24766.84.camel@Joe-Laptop> <20110421195801.GA15126@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Apr 2011 13:09:11 -0700
Message-ID: <BANLkTinWV_OriM0mdoVdKWZNHhEUUmWDog@mail.gmail.com>
Subject: Re: annoying new gcc 4.6.0 warnings.
To: Dave Jones <davej@redhat.com>, Joe Perches <joe@perches.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:58 PM, Dave Jones <davej@redhat.com> wrote:
> @@ -359,7 +359,8 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>                   -fno-strict-aliasing -fno-common \
>                   -Werror-implicit-function-declaration \
>                   -Wno-format-security \
> -                  -fno-delete-null-pointer-checks
> +                  -fno-delete-null-pointer-checks \
> +                  -Wno-unused-but-set-variable

Does this work ok for older gcc's? Do they understand that
-Wno-unused-by-set-variable?

gcc-4.5.1 seems to understand it, but what about much older gccs?

                 Linus
