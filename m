Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767683Ab2KOMZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:25:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993328Ab2KOMZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:25:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/2] Boottime: A tool for automatic measurement of kernel/bootloader boot time
Date: Thu, 15 Nov 2012 12:25:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Kyungmin Park <kmpark@infradead.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, jonas.aberg@stericsson.com,
        will.deacon@arm.com,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
References: <1352973847-21605-1-git-send-email-lee.jones@linaro.org> <CAH9JG2UX0Wyr-QKw3=tbUXeuEhHe04_cFkkAp6bB2Rr-x7ViHQ@mail.gmail.com> <20121115112543.GC21682@gmail.com>
In-Reply-To: <20121115112543.GC21682@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151225.31066.arnd@arndb.de>
X-Provags-ID: V02:K0:JkpwSqC711g1KZXrYXwChBjxaFAnu1hG85Ly09kZSzk
 b/fK6yd1e7YAVLgwPyvbueMZME3hdSIno6A5CCRpUx5lHye6Kk
 ZnyxWJflOq8LXFxL/fAvSoUtmQJAGv4m2h0MS6Nf/XxGKCTYWL
 qR3AjRN7Hj+P8aW3mnpmSAz5srxIcfoyAqUxAbt0NpaXQq1RWK
 4ePsf4+fxr56M7OW2yZOSQU9As0dz8KBL79TFWhy+S12EqIX/c
 KNrKT91ipKib0IUqhJ1u0vd2ihhhMr4ZAZoA1j55Qcjl762Bil
 LoECnL2Ckgg2WCCyMMvfeoOehJ3NKfobkH3thGXL9H3Tb9lUKR
 zFROpLlUabOynlruUrRw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Lee Jones wrote:
> 
> > > +/* for automatic boot timing testcases */
> > > +#define ATAG_BOOTTIME  0x41000403
> > Where can I refer this ATAG usage? can you point out the reference URL
> > or patches?
> 
> I assumed this would be in Mainline u-boot, but apparently not.
> On closer inspection of the internal ST-Ericsson u-boot, this
> functionality appears to be provided by patches which currently
> exist as delta. So in essence, the bootloader you use will have
> to be patched in a similar way for you to retrieve information
> surrounding bootloader boot times.
> 
> And there was me thinking it was magic. ;)
> 

And since we're moving away from ATAG on ux500 towards DT, it won't
even work in the future. How essential is this part for the operation
of your code?

	Arnd
