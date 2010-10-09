Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359Ab0JISjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:39:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091Ab0JISjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:39:52 -0400
MIME-Version: 1.0
In-Reply-To: <4CB0AF2A.2010605@kernel.org>
References: <20101008213429.GB7223@sgi.com> <4CAFA1DB.6010802@kernel.org>
 <20101009125944.GA18248@sgi.com> <20101009163908.GX14068@sgi.com> <4CB0AF2A.2010605@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Oct 2010 11:39:01 -0700
Message-ID: <AANLkTi=53ZAQtaL4ZZ7iA-ZsvKJyeqW8z_+Zi4_wds0t@mail.gmail.com>
Subject: Re: [BUG] x86: bootmem broken on SGI UV
To: Yinghai Lu <yinghai@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Russ Anderson <rja@sgi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 11:06 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> It is too late for put in 2.6.36. Linus already had -rc7, and assume he will have final .36 this week.

Anything that is worth tagging for stable is worth fixing before the
final release (probably Wednesday).

But I do want it tested and confirmed, and acked by lots of people.
And preferably get it through the normal channels too.

                    Linus
