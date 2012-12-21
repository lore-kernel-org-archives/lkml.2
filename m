Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2LUQQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:16:15 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:36641 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2LUQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <CABqxG0cFTu2qDo6RmZ7QfLsC4fDzLVj9WrocuDAz+dAQB8OJ6Q@mail.gmail.com>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
	<1354139277-17376-6-git-send-email-yinghai@kernel.org>
	<CABqxG0cFTu2qDo6RmZ7QfLsC4fDzLVj9WrocuDAz+dAQB8OJ6Q@mail.gmail.com>
Date: Fri, 21 Dec 2012 08:16:05 -0800
X-Google-Sender-Auth: cG_RZR_LLupSbtwTSq2Naerw9p0
Message-ID: <CAE9FiQU+8xAKQ20C7ZMFGGq8p7=TY9OpK3nf7V=uwDZoqSM2ig@mail.gmail.com>
Subject: Re: [PATCH v9 05/46] x86, mm: Revert back good_end setting for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 12:22 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> What's the staus of this patch,  will it go for 3.8? Is there anything
> blocking this patch?

no.

Now it is in tip:x86/mm2.

it should be go with for-x86-boot for 3.9

Yinghai
