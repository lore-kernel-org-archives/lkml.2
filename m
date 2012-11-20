Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2KTUzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:55:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48788 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2KTUzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:55:43 -0500
MIME-Version: 1.0
In-Reply-To: <23b6f8fe-37cd-4cbb-9c90-511dab4e5b5b@email.android.com>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
	<1353222571-31544-4-git-send-email-yinghai@kernel.org>
	<50AAB5E8.5070807@zytor.com>
	<CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com>
	<50AABD15.1050809@zytor.com>
	<CAE9FiQVMsBS-c+H7+q3hi5hdvcZ8_AYqm5RV_dOVbV9L1UnxTA@mail.gmail.com>
	<41603b4d-cd34-4c6e-9e1f-ac78816b5097@email.android.com>
	<CAE9FiQVAxkS6AH6zDJAjuyiJtR2xztRG+raCk4L6yvKuskzBkg@mail.gmail.com>
	<CAE9FiQVrjRvQYNDdJFcyDFrr88B6v-86Zdq5a15kdHN_byDG3g@mail.gmail.com>
	<23b6f8fe-37cd-4cbb-9c90-511dab4e5b5b@email.android.com>
Date: Tue, 20 Nov 2012 12:55:41 -0800
X-Google-Sender-Auth: zW47f4fBaoToP3kkOaBNQIFUp58
Message-ID: <CAE9FiQUjZG_UakYdpxEf8_EHQ4UBo6GK1E_g4wDY576MFcVL4Q@mail.gmail.com>
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

On Tue, Nov 20, 2012 at 12:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I don't see any point in three flags here.  Let's stick to one flag; then it fits in the existing boot_flags field.

the magic AA55

boot/header.S:boot_flag:        .word 0xAA55

if change that to other value, would it break existing boot loader?
aka old boot loader could boot the new bzImage anymore.

Thanks

Yinghai
