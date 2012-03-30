Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696Ab2C3XdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:33:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61243 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761759Ab2C3XdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <4F763EAF.2070904@xenotime.net>
References: <4F76196A.9070709@xenotime.net> <CA+55aFz0WyVfJgO9GDM4ssUoWPRZfY0rs+97+P6fmYtc-jnDCw@mail.gmail.com>
 <4F763EAF.2070904@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Mar 2012 16:32:46 -0700
X-Google-Sender-Auth: uYbUOspw-XtdqMDU1dUoPFwgiH4
Message-ID: <CA+55aFwFPPYypug7ZHSKiG+ibDGx8VtAjBfiXLJ=yKWE6o327Q@mail.gmail.com>
Subject: Re: [PATCH 1/8] Documentation: remove 'mach' from dontdiff file
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 4:15 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> Shall I resend all of these?

No, I went through and fixed them up since I noticed. But sometimes I
don't notice, and I know for a fact that other submaintainers also
don't notice, so we've got tons of those duplicate lines in our tree.
Just fix your future patches.

The last one also didn't apply cleanly for some reason. I didn't
figure out what made it not apply, I tried several different versions
and then just decided to force the patch manually. I wonder what base
you had used..

              Linus
