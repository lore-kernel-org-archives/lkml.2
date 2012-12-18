Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2LRAg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:36:59 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:42455 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2LRAg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:36:58 -0500
MIME-Version: 1.0
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220470F859C@ORSMSX105.amr.corp.intel.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
	<1355654609-16800-9-git-send-email-fenghua.yu@intel.com>
	<CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
	<50CE4097.2020104@zytor.com>
	<CAE9FiQXmz07SUEwJdr0QD8Y2Uro6Sizkeg4KfFkJSuQLFW3Fow@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F81EE@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQUqJVJ6JSeGzFH+OtRA4syrbXZh-RJLSghvB8fdBt97oQ@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F8584@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQVQMumUSgJ91rT5Zr2_Q=Wk=jBy+MEA3Li0Y215OHQT_Q@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F859C@ORSMSX105.amr.corp.intel.com>
Date: Mon, 17 Dec 2012 16:36:56 -0800
X-Google-Sender-Auth: lNZcJTwzMQReAhNpxUAqpv84k8s
Message-ID: <CAE9FiQXyHXgR3O0BW7TdckpO4UOytfXysgVJ-D8D7yzMTW__Sg@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
From: Yinghai Lu <yinghai@kernel.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 4:32 PM, Yu, Fenghua <fenghua.yu@intel.com> wrote:
>> >
>> it has to be after #PF handler set page table patch...
>>
>> otherwise when ramdisk is above 1G, customer will get early PF
>> exception.
>
> In old kernel, where can I put load_ucode_bsp()? Is calling load_ucode_bsp() after relocate_initrd() earliest place?

after init_memory_mapping.
