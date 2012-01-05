Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab2AERRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:17:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61254 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab2AERRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:17:04 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1325654761.28596.3.camel@joe2Laptop>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	<1325610682-24811-3-git-send-email-olof@lixom.net>
	<1325654761.28596.3.camel@joe2Laptop>
Date: Thu, 5 Jan 2012 09:17:02 -0800
Message-ID: <CAOesGMhZ5H3+vOA6DdCdFdXjUHHkmLk8EDk_eJQD9Q2WqVL-mg@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86: efi: convert printk to pr_*()
From: Olof Johansson <olof@lixom.net>
To: Joe Perches <joe@perches.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 9:26 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-01-03 at 09:11 -0800, Olof Johansson wrote:
>> Alright, I guess I'll go through and convert them, even though
>> there's no net gain to speak of.
>
> Perhaps it'd be better to add
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any #include and remove PFX from the
> formats

I'm not sure it's much of a net gain, PFX was used only a couple of
times, the other printouts were just plain ones.

Anyway, I've switched to pr_fmt anyway, and reworded some of the
messages to not have redundant EFI's in them.

Thanks,

-Olof
