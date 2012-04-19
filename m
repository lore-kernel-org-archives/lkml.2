Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2DSAvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:51:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43147 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2DSAvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BL8bKauB6-srbZCLapHJNAVRqB0g0uw+17_h1wy3_9-g@mail.gmail.com>
References: <alpine.DEB.2.00.1204151350450.13924@eristoteles.iwoars.net>
	<CAOMZO5BL8bKauB6-srbZCLapHJNAVRqB0g0uw+17_h1wy3_9-g@mail.gmail.com>
Date: Wed, 18 Apr 2012 21:51:21 -0300
Message-ID: <CAOMZO5Cc0hWobNW4y-Di7F3D_LHS1cj+c4w-gNaK9t2NxKpE3A@mail.gmail.com>
Subject: Re: mtdchar kernel oops
From: Fabio Estevam <festevam@gmail.com>
To: Joel Reardon <joel@clambassador.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 11:19 AM, Fabio Estevam <festevam@gmail.com> wrote:
> On Sun, Apr 15, 2012 at 8:58 AM, Joel Reardon <joel@clambassador.com> wrote:
>> I think that this patch:
>> "mtdchar: kill persistently held vfsmount"
>> http://permalink.gmane.org/gmane.linux.kernel.commits.head/314175
>>
>> has started causing kernel oops's when running ubiformat. The oops is
>> occuring in fs/namespace.c's mnt_add_count() line:
>>        this_cpu_add(mnt->mnt_pcp->mnt_count, n);
>
> I also see kernel oops when running flash_eraseall on a SPI NOR flash.
>
> If this patch is reverted the flash_eraseall operation is successful.

I am no longer getting kernel oops on 3.4.0-rc3-next-20120418.
