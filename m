Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0IZRAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 13:00:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab0IZRAd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 13:00:33 -0400
MIME-Version: 1.0
In-Reply-To: <20100926115354.GA30247@osdn.org.ua>
References: <20100827213629.GA11342@osdn.org.ua> <20100923165022.6982ffc1.akpm@linux-foundation.org>
 <20100926115354.GA30247@osdn.org.ua>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 Sep 2010 10:00:00 -0700
Message-ID: <AANLkTiniAprv-rz0QQD540g7S1jbj8Na+e78Ro2R8Koa@mail.gmail.com>
Subject: Re: fs hang in 2.6.27.y | Fwd: [Bug 15658] New: [PATCH] x86
 constant_test_bit() prone to misoptimization with gcc-4.4
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>,
        Alexander Chumachenko <ledest@gmail.com>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 4:53 AM, Michael Shigorin <mike@osdn.org.ua> wrote:
>
> The simplicity of adding that somewhat went over my head --
> please find attached the corrected original patch against HEAD
> with Signed-off-by: for both of us.  led@ didn't change cosmetics
> -- thanks for providing it anyways.

Ok, I think this patch is probably the right thing to do at this stage
- and we should think about trying to see if we can improve code
generation later.

So: "Acked-by: Linus Torvalds <torvalds@linux-foundation.org>"

Ingo/Thomas/Peter - I can take this either from the x86 tree, or
directly. Just let me know. Or do you have any alternate suggestions
that would be appropriate?

                           Linus
