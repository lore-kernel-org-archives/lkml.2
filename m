Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab1JWKPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:15:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56777 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1JWKPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:15:30 -0400
Message-ID: <4EA3E926.80203@zytor.com>
Date: Sun, 23 Oct 2011 12:15:02 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Xin Tong <xerox.time.tech@gmail.com>
CC: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: copy_*_user
References: <CALKntY3Xo6R2zLs8oM=+=-VPdFXeLsdGi_YbMiA_1085xhMOQw@mail.gmail.com> <CAM_iQpU+xHww_JCYYA4kAKCXmOZpZeu=+rnCyRL-5dW5Uxk1hQ@mail.gmail.com> <CALKntY0222DBU88W=j0Y2FpN7NRMSxmDk4XKy-m+keri4Gcu_A@mail.gmail.com>
In-Reply-To: <CALKntY0222DBU88W=j0Y2FpN7NRMSxmDk4XKy-m+keri4Gcu_A@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2011 11:23 AM, Xin Tong wrote:
> I found that __copy_from_user_ll(void *to, const void __user *from,
> unsigned long n) eventually calls some asm which use mov and rep on
> the passed-in to & from pointers. This is in kernel mode and to & from
> are virtual addresses ? are not the kernel accessing physical RAM
> directly ( without pagetable ) ?

No.  What gave you that idea?

	-hpa

