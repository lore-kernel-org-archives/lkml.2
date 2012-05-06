Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2EFRQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:16:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56787 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2EFRQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120506162000.GT6871@ZenIV.linux.org.uk>
References: <20120506162000.GT6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 6 May 2012 10:16:11 -0700
X-Google-Sender-Auth: QjQ9EvdYG-oNqz5fj6bIQeTw8ds
Message-ID: <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com>
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 9:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Setting TIF_IA32 in load_aout_binary() used to be enough; these days
> TASK_SIZE is controlled by TIF_ADDR32 and that one doesn't get set
> there.  Switch to use of set_personality_ia32()...

Applied. Just out of curiosity, how did you notice? Just looking at
TIF_IA32 usage, or do you actually have some old app?

                   Linus
