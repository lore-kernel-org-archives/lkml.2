Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2KUAeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:34:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62356 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2KUAee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:34:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVMBBHoi4pr2VGo8jWbqPpOzt62w51Rk-v=RMxddJkdSg@mail.gmail.com>
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
	<CAE9FiQUjZG_UakYdpxEf8_EHQ4UBo6GK1E_g4wDY576MFcVL4Q@mail.gmail.com>
	<50ABF23A.7020305@zytor.com>
	<CAE9FiQUBz-QLAaeyOd7E_Gzpq3m0jZOPp4+hTfdo5PaDZHRerQ@mail.gmail.com>
	<50AC2022.5030207@zytor.com>
	<CAE9FiQVMBBHoi4pr2VGo8jWbqPpOzt62w51Rk-v=RMxddJkdSg@mail.gmail.com>
Date: Tue, 20 Nov 2012 16:34:33 -0800
X-Google-Sender-Auth: LTtWv3ZRRykBbhc51Dby8VTcBJs
Message-ID: <CAE9FiQXibjTQOGL9a1EJD=nCe4AjbF0kqOaOSXi3tm4u0zF26Q@mail.gmail.com>
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

On Tue, Nov 20, 2012 at 4:32 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Nov 20, 2012 at 4:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/20/2012 04:20 PM, Yinghai Lu wrote:
>>>
>>>> relocatable_kernel really should have been a flag, but it is now defined as
>>>> a comparison with zero.  As such, and in an effort to minimize the growth of
>>>> struct setup_header (it is limited to little over 128 bytes long) I suggest
>>>> we redefine the 16-byte field at offset 0x236 as a new flags field.  We
>>>> still only need one flag, though.
>
> ok will use 0x236.

how to call it?

boot_flag2 ?
