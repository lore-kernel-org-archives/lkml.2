Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab1HDAwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 20:52:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913Ab1HDAwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 20:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1108031523080.22067@x980>
References: <alpine.LFD.2.02.1108031137590.22067@x980> <CA+55aFxST2J+LDMB=1ctnw2WGxV+a-cm3FE-1AjwnXMNDkt32g@mail.gmail.com>
 <alpine.LFD.2.02.1108031523080.22067@x980>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Aug 2011 14:52:26 -1000
Message-ID: <CA+55aFxE6b=idv+fF5h1U3EnDqHSCK2b6+36sResmhJKvAZQ3A@mail.gmail.com>
Subject: Re: [GIT PATCH] APEI patches for Linux 3.1
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 9:26 AM, Len Brown <lenb@kernel.org> wrote:
>
> Push went here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git apei-release

No it didn't.

Apparently it went into linux-idle.

Christ, Len. You send me *two* bogus pull requests, and all your pull
requests  come in at the very end of the merge cycle, when I very
clearly asked people to try hard to avoid that since I'm supposed to
be on vacation.

And several of those commits are from today, and cannot have had any testing.

In short: even though Tony told me where to look, I'm not seeing any
reason to pull this thing. The merge window is not for development,
and you're simply not making me get the warm and fuzzies about this
late pull request.

             Linus
