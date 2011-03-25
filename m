Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1CYQyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:54:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182Ab1CYQye convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:54:34 -0400
MIME-Version: 1.0
In-Reply-To: <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
References: <20110317192208.444147791@goodmis.org> <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Mar 2011 09:45:58 -0700
Message-ID: <AANLkTikfq9bz_cKdvq9ab+KS218Q7uVvoNdJeMe_-RUg@mail.gmail.com>
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Allow use in if() statements on UP
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, torvalds@linux-foundation.org,
        peterz@infradead.org, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 3:48 AM, tip-bot for Steven Rostedt
<srostedt@redhat.com> wrote:
> -# define WARN_ON_SMP(x)                        do { } while (0)
> +# define WARN_ON_SMP(x)                        ({0;})

That's a VERY odd way of writing "0".

Am I missing something subtle?

                        Linus
