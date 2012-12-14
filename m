Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2LNAoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:44:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54894 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2LNAoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:44:05 -0500
MIME-Version: 1.0
In-Reply-To: <50CA7515.9080701@zytor.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-20-git-send-email-yinghai@kernel.org>
	<50CA6478.20008@zytor.com>
	<CAE9FiQURsKT8Ufy7NmWUzrzkYoH65Edk6e_kJkw_+YYx=1bXTg@mail.gmail.com>
	<50CA7515.9080701@zytor.com>
Date: Thu, 13 Dec 2012 16:44:03 -0800
X-Google-Sender-Auth: JulEA-E-dr85DKg-X9F6_WBJR0U
Message-ID: <CAE9FiQXi6XZ9_7CDS_Ypgd59tSouhw8TCePCdJQNC7bhGMO8WQ@mail.gmail.com>
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

On Thu, Dec 13, 2012 at 4:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/13/2012 04:13 PM, Yinghai Lu wrote:
>
> It is definitely the minmum we can rely on, and so is the minimum we should
> rely on.  In fact, we don't even need .bss/.brk to be mapped, but we
> probably should require that as a matter of protocol.

in my version of arch/x86/kernel/head_64.S is using BRK to do
ident/kernel high mapping
for kernel that is above 4G.
so .brk is needed.
