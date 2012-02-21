Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2BUMlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:41:35 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51362 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab2BUMld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:41:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jiangtao.jit@gmail.com designates 10.152.148.230 as permitted sender) smtp.mail=jiangtao.jit@gmail.com; dkim=pass header.i=jiangtao.jit@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4262A4.9000204@gmail.com>
References: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com>
	<CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com>
	<4F411373.50304@gmail.com>
	<CAOe6JY3yM24CGYOpPc98QfjRYah5U+L9DB46WH60LVrxN9=eRQ@mail.gmail.com>
	<4F4262A4.9000204@gmail.com>
Date: Tue, 21 Feb 2012 20:41:32 +0800
Message-ID: <CAOe6JY1_dYGCK2=+EHARz5mTm=KCgWynnJjA9SuEHfj+Z0xjwA@mail.gmail.com>
Subject: Re: A problem with percpu variable cpu_number
From: Tao Jiang <jiangtao.jit@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cong Wang:

I read the file vmlinux.lds.S in arch/x86/kernel
section .data..percpu is between .init.data and .init.end
Is that means these percpu variables will be freed after init?

Thank you.


2012/2/20 Cong Wang <xiyou.wangcong@gmail.com>:
> On 02/20/2012 07:04 PM, Tao Jiang wrote:
>>
>>
>> I read the macor DEFINE_PER_CPU
>> it's decorated by some percpu attributes
>> it will be put in section .data..percpu in init section
>
>
> .data..percpu is not .init section, the .init sections should all have
> ".init.*" names.
