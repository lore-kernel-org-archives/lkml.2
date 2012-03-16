Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2CPVWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:22:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723Ab2CPVWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:22:48 -0400
Message-ID: <4F63AF10.9030101@zytor.com>
Date: Fri, 16 Mar 2012 14:22:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, josh@joshtriplett.org,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Merge x86_32 and x86_64 cpu_idle()
References: <1331929109-22137-1-git-send-email-richard@nod.at>
In-Reply-To: <1331929109-22137-1-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 01:18 PM, Richard Weinberger wrote:
> +/*
> + * The idle thread. There's no useful work to be
> + * done, so just try to conserve power and have a
> + * low exit latency (ie sit in a loop waiting for
> + * somebody to say that they'd like to reschedule)
> + */
> +void cpu_idle()

Thou shalt not, in the language of C, under any circumstances, on the
pain of death, declare or define a function with an empty set of
parentheses, for though in the language of C++ it meaneth the same as
(void), in C it meaneth (...) which is of meaningless as there be no
anchor argument by which the types of the varadic arguments can be
expressed, and which misleadeth the compiler into allowing unsavory code
and in some cases generate really ugly stuff for varadic handling.

	-hpa
