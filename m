Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1LLUNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:13:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41527 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1LLUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:13:17 -0500
Message-ID: <1323720791.2583.23.camel@edumazet-laptop>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>
Date: Mon, 12 Dec 2011 21:13:11 +0100
In-Reply-To: <1323718578-1157-3-git-send-email-asharma@fb.com>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
	 <1323718578-1157-3-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 11:36 -0800, Arun Sharma a écrit :
> From: Kumar Sundararajan <kumar@fb.com>
> 

...

> +
> +struct vcpu_data {
> +	struct vpercpu_data vpercpu[NR_CPUS];
> +	unsigned int tsc_khz;
> +	unsigned int tsc_unstable;
> +};

Thats a showstopper.

Try to compile the thing with NR_CPUS=4096 ?


