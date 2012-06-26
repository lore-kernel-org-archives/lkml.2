Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab2FZReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:34:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39512 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524Ab2FZRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1206211204430.10229@xanadu.home>
References: <1340269017-11701-1-git-send-email-richard.genoud@gmail.com> <alpine.LFD.2.02.1206211204430.10229@xanadu.home>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 26 Jun 2012 19:34:18 +0200
Message-ID: <CACQ1gAgeFTW_Tw05uaOeVnuDLYQ4b7XNv4xAbV249Gc01LEs8w@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: Allow DTB command line concatenation with ATAG_CMDLINE
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/21 Nicolas Pitre <nicolas.pitre@linaro.org>:
> On Thu, 21 Jun 2012, Richard Genoud wrote:
>
>> This patch allows the ATAG_CMDLINE provided by the bootloader to be
>> concatenated to the bootargs property of the device tree.
>>
>> This is useful to merge static values defined in the device tree with the
>> boot loader's (possibly) more dynamic values, such as startup reasons and more.
>>
>> The bootloader should use the device tree to pass those values to the kernel,
>> but that's not always simple (old bootloader or very small one).
>>
>> The behaviour is the same as the one introduced by Victor Boivie in
>> 4394c1244249198c6b85093d46935b761b36ae05 by extending the CONFIG_CMDLINE.
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>
> Acked-by: Nicolas Pitre <nico@linaro.org>

As it has been acked by Nicolas, I sent it to the Russell's patch subsystem :

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7437/1

Richard.
