Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2AQOiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:38:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61927 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab2AQOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:38:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120117142759.GE16213@moon>
References: <20120117142759.GE16213@moon>
Date: Tue, 17 Jan 2012 16:38:14 +0200
Message-ID: <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> +#define KCMP_EQ		0
> +#define KCMP_LT		1
> +#define KCMP_GT		2

LT and GT are meaningless.
