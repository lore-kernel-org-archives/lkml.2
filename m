Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2ICFbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:31:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37703 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2ICFbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:31:45 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-9-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-9-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:31:43 +0300
X-Google-Sender-Auth: bfIB5bDSr6SYxqHwCQ3gc7bdMkk
Message-ID: <CAOJsxLF-FyPGAqPVg4jaRmPvsjreb=SfrJ7puB_dX1ksM_kg1Q@mail.gmail.com>
Subject: Re: [PATCH -v2 08/13] x86: if kernel .text .data .bss are not marked
 as E820_RAM, complain and fix
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> From: Jacob Shin <jacob.shin@amd.com>
>
> There could be cases where user supplied memmap=exactmap memory
> mappings do not mark the region where the kernel .text .data and
> .bss reside as E820_RAM, as reported here:
>
> https://lkml.org/lkml/2012/8/14/86
>
> Handle it by complaining, and adding the range back into the e820.
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

This should have Yinghai's sign-off and the warning could be less cryptic.

As for the fix itself:

Reviewed-by: Pekka Enberg <penberg@kernel.org>
