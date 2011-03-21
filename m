Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1CUTYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:24:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab1CUTYf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110320.195156.226769634.davem@davemloft.net>
References: <20110320.195156.226769634.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Mar 2011 12:24:12 -0700
Message-ID: <AANLkTinN3qszBjbJdkXb2TPBkAW0mXGC=Ri1zKL9gdNg@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 20, 2011 at 7:51 PM, David Miller <davem@davemloft.net> wrote:
>
> 1) The R8169 PHY fix from Eric Dumazet, which I see you've added to
>   your tree too. :-)

Yeah, since my machine didn't have networking without it, and I could
test it myself, I didn't wait to pull.

That said, I'm delaying this pull request due to the known issues with
it - let me know when you've updated it with the fix for the
use-after-free fixes and the slab corruptor (the latter of which I
haven't seen a patch for yet)

                         Linus
