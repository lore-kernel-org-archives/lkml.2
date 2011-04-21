Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1DUTZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:25:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab1DUTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:25:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110421192117.GA14249@redhat.com>
References: <20110421192117.GA14249@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Apr 2011 12:24:26 -0700
Message-ID: <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
Subject: Re: annoying new gcc 4.6.0 warnings.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:21 PM, Dave Jones <davej@redhat.com> wrote:
>
> There might be some valid bugs found (I think DaveM found a few already) from this new
> warning, but it seems like everything I've looked at so far is just noise.
>
> Any thoughts ?

Yeah, let's just disable the crazy warning. Maybe some of them are
valid, but it's like the f*cking sign-compare warning: most of them
are just inane noise, and as such the warning is not worth the pain.

I assume (hope) that there is some -Wno-unused-but-set-variable thing
we could do, the same way we do -Wno-trigraphs for another totally
useless gcc warning.

                       Linus
