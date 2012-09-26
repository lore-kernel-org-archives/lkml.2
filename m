Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2IZLqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:46:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63473 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab2IZLqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:46:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120926114024.GA26353@gmail.com>
References: <1348577479-2564-1-git-send-email-fweisbec@gmail.com>
	<20120926114024.GA26353@gmail.com>
Date: Wed, 26 Sep 2012 13:46:33 +0200
Message-ID: <CAFTL4hzjrHnvG-=HEF7JHAxRcU_G5DGu-mLmc_jPxxVh8eHrXA@mail.gmail.com>
Subject: Re: [PATCH] x86: Unspaghettize do_trap()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/26 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> +             return -1
>
> this bit wasn't very well tested. I applied it with the obvious
> fix, lets hope it holds up in testing.

Ouch. Bad indeed. I booted with x86-64 but forgot to try x86-32.

Sorry about that.
