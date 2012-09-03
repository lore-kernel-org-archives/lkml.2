Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2ICFci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:32:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51771 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2ICFch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-10-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-10-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:32:36 +0300
X-Google-Sender-Auth: TtTHS-CXAzGjuX0tcHwivJ4KZTg
Message-ID: <CAOJsxLFKQtJM1sjeBaoMjmVaOUyXf1DHMaBuEohCLgaRFLr+KQ@mail.gmail.com>
Subject: Re: [PATCH -v2 09/13] x86: Fixup code testing if a pfn is direct mapped
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
> Update code that previously assumed pfns [ 0 - max_low_pfn_mapped ) and
> [ 4GB - max_pfn_mapped ) were always direct mapped, to now look up
> pfn_mapped ranges instead.

What problem does this fix? How did you find about it?

> -v2: change applying sequence to keep git bisecting working.
>      so add dummy pfn_range_is_mapped(). - Yinghai Lu
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Yinghai's sign-off is missing.
