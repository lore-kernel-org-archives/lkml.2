Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2K1Xtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:49:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60192 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2K1Xtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:49:46 -0500
MIME-Version: 1.0
In-Reply-To: <50B6881F.7090101@zytor.com>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
	<50B6881F.7090101@zytor.com>
Date: Wed, 28 Nov 2012 15:49:44 -0800
X-Google-Sender-Auth: xnva2XauDiWAL8zcuNGexP0lXuQ
Message-ID: <CAE9FiQUCiyhoWSS4OnZ5zhLJhtiYL1MU2tFwZYAA6w6yQG500g@mail.gmail.com>
Subject: Re: [PATCH v9 00/46] x86, mm: map ram from top-down with BRK and memblock.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 1:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/28/2012 01:47 PM, Yinghai Lu wrote:
>> rebase patchset on top of linus v3.7-rc4. this one replace patches in tip/x86/mm2
>
> What are the changes?  Given how close we are to the merge window, if we
> replace the entire patchset we are *definitely* slipping this to 3.9.
> Depending on what the changes are we might not have to do so, but we
> need them detailed.

no code change.

only update some changelog  and one comments, and add acked-by from Konrad.

Thanks

Yinghai
