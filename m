Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2JAH3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 03:29:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51610 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2JAH27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 03:28:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209281336380.21335@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com>
	<00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com>
	<alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
	<5062C029.308@parallels.com>
	<alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com>
	<5063F94C.4090600@parallels.com>
	<alpine.DEB.2.00.1209271552350.13360@chino.kir.corp.google.com>
	<0000013a0d390e11-03bf6f97-a8b7-4229-9f69-84aa85795b7e-000000@email.amazonses.com>
	<alpine.DEB.2.00.1209281336380.21335@chino.kir.corp.google.com>
Date: Mon, 1 Oct 2012 10:28:58 +0300
X-Google-Sender-Auth: fvpMrnz_rYs7q7Dnhfm9tBTDXpE
Message-ID: <CAOJsxLFYSKqq-JexK1Q7NEtQmxtJnWB-WwbNyp9tk9mpAh6vGg@mail.gmail.com>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>, Glauber Costa <glommer@parallels.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[ Found this in my @cs.helsinki.fi inbox, grmbl. ]

On Fri, Sep 28, 2012 at 11:39 PM, David Rientjes <rientjes@google.com> wrote:
> The first prototype, SLAM XP1, will be posted in October.  I'd simply like
> to avoid reverting this patch down the road and having all of us
> reconsider the topic again when clear alternatives exist that, in my
> opinion, make the code cleaner.

David, I'm sure you know we don't work speculatively against
out-of-tree code that may or may not be include in the future...

That said, I don't like Glauber's patch because it leaves CREATE_MASK
in mm/slab.c. And I'm not totally convinced a generic SLAB_INTERNAL is
going to cut it either. Hmm.

                        Pekka
