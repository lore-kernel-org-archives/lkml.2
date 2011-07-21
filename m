Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1GUFPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 01:15:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52230 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1GUFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 01:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110717144746.78063c97.rdunlap@xenotime.net>
References: <20110707171627.4f15035e.akpm@linux-foundation.org>
	<20110717144746.78063c97.rdunlap@xenotime.net>
Date: Thu, 21 Jul 2011 13:15:33 +0800
Message-ID: <CAM_iQpX02nB90mcRSpvc-DfMsGTDZQ88oK-uKm8TECuoPBE_=A@mail.gmail.com>
Subject: Re: `make headers_check' bustage
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 5:47 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Thu, 7 Jul 2011 17:16:27 -0700 Andrew Morton wrote:
>
>> It is just me, or is headers_check busted in current -linus?
>>
>> z:/usr/src/25> make mrproper; make allmodconfig; make headers_check
>> ...
>> /usr/src/25/usr/include/linux/kernel.h:65: userspace cannot reference function or variable defined in the kernel
>> /usr/src/25/usr/include/linux/quota.h:175: userspace cannot reference function or variable defined in the kernel
>> /usr/src/25/usr/include/linux/sdla.h:116: userspace cannot reference function or variable defined in the kernel
>> /usr/src/25/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel
>
> What does it take to reproduce this?
> Does it fail on either type of X86 or is this from some other $ARCH?
> I can't make it fail on X86 (3.0-rc7).

If you have CONFIG_HEADERS_CHECK=y in your .config,
make headers_check will be invoked after compiling is done.
