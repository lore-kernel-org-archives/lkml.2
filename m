Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0GTT3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:29:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab0GTT3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:29:31 -0400
Date: Tue, 20 Jul 2010 12:28:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, numa: fix boot without RAM on node0 again
Message-Id: <20100720122831.f1aad864.akpm@linux-foundation.org>
In-Reply-To: <4C45F5F0.8010409@zytor.com>
References: <4C45EC59.3030304@kernel.org>
	<4C45F5F0.8010409@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 12:16:00 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 07/20/2010 11:35 AM, Yinghai Lu wrote:
> 
> That was not what Linus (and I) asked you to do.  He asked specifically
> that you resend them under a separate 0/2 cover with an explanation.
> 

And this patch is missing my patch which fixed up that block comment.

I'll send both these patches into Linus today.  I'm a bit behind due to
various linux-next catastrophies.

Catastrophies which have been known about for up to a week, yet all the
offending patches are still in linux-next, unaltered.  Go figure.

