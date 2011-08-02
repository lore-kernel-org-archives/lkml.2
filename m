Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1HBBmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:42:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab1HBBl7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110801183207.cea89a96.akpm@linux-foundation.org>
References: <20110802005206.GA3832@tassilo.jf.intel.com> <20110801183207.cea89a96.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Aug 2011 15:41:37 -1000
Message-ID: <CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com>
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 3:32 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> aw, what crap.
>
> "/proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead."
>
> Once per boot.  That's not "scary".

It is when there is that totally pointless stack trace, and the kernel
bug reporting tool picks it up and tells the user that there was a
kernel oops.

Which it really does.

So if it was a "printk_once()" it would be fine. The WARN_ONCE() is
just annoying.

             Linus
