Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab2LNBAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:00:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2LNBAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:00:15 -0500
MIME-Version: 1.0
In-Reply-To: <50CA78AC.3060700@zytor.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-20-git-send-email-yinghai@kernel.org>
	<50CA6478.20008@zytor.com>
	<CAE9FiQURsKT8Ufy7NmWUzrzkYoH65Edk6e_kJkw_+YYx=1bXTg@mail.gmail.com>
	<50CA7515.9080701@zytor.com>
	<CAE9FiQXi6XZ9_7CDS_Ypgd59tSouhw8TCePCdJQNC7bhGMO8WQ@mail.gmail.com>
	<CAE9FiQXSSbWOp=DqGiH2gyuR4FvTaLot4CnSm3KGqcgmj4p34A@mail.gmail.com>
	<50CA78AC.3060700@zytor.com>
Date: Thu, 13 Dec 2012 17:00:13 -0800
X-Google-Sender-Auth: 2lGX_QbPBtMPR4zOJ2eOnoi4r-4
Message-ID: <CAE9FiQXp8kiHus3s-TYtAKzzZHqgfmsv-PpHDqgd56b1Re3B-g@mail.gmail.com>
Subject: Re: [PATCH v6 19/27] x86, boot: update comments about entries for
 64bit image
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 4:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/13/2012 04:51 PM, Yinghai Lu wrote:

>> also need to make sure zero page and command line get ident mapping.
>> because arch/x86/boot/compressed/head_64.S is using them.
>>
>
> ... or we need to do the same kind of thing there.
>
your #PF handler approach will  handle accessing kernel code together
with zero_page, command_line, ramdisk ?
so only need to map first 2M?
