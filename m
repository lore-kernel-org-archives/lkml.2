Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2KTAjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:39:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49926 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2KTAjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:39:39 -0500
MIME-Version: 1.0
In-Reply-To: <41603b4d-cd34-4c6e-9e1f-ac78816b5097@email.android.com>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
	<1353222571-31544-4-git-send-email-yinghai@kernel.org>
	<50AAB5E8.5070807@zytor.com>
	<CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com>
	<50AABD15.1050809@zytor.com>
	<CAE9FiQVMsBS-c+H7+q3hi5hdvcZ8_AYqm5RV_dOVbV9L1UnxTA@mail.gmail.com>
	<41603b4d-cd34-4c6e-9e1f-ac78816b5097@email.android.com>
Date: Mon, 19 Nov 2012 16:39:37 -0800
X-Google-Sender-Auth: XeIfC7cUDqMtHNqf1Zsx-wYUs8M
Message-ID: <CAE9FiQVAxkS6AH6zDJAjuyiJtR2xztRG+raCk4L6yvKuskzBkg@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] x86: Add macro for 64bit entry startup_64
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 3:55 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> We probably should add a flag for those, but that is more of a boot_flag...

kernel_cap_bits:
RAMDISK_ABOVE_4G  = (1<<0)
KERNEL_ABOVE_4G =(1<<2)
CMD_LINE_ABOVE 4G = (1<<1)
                .long   (RAMDISK_ABOVE_4G | CMD_LINE_ABOVE_4G | KERNEL_ABOVE_4G)
