Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1KPGfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 01:35:02 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33139 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab1KPGfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 01:35:00 -0500
MIME-Version: 1.0
In-Reply-To: <20111116143632.914b0f0cc828d90d6ec371f6@canb.auug.org.au>
References: <CA+55aFzWkXNtLe4jxuXfTJzbXgDF+ig2OuGY3ca+nNCJxAtOZQ@mail.gmail.com>
	<20111116143632.914b0f0cc828d90d6ec371f6@canb.auug.org.au>
Date: Wed, 16 Nov 2011 08:34:58 +0200
X-Google-Sender-Auth: 52n2ATYlgXg1glfzj1iPRSQN-H8
Message-ID: <CAOJsxLFQk0kzmjnr0ds1-JJy3KBdGu-txsb06Na0kPg5LZA3vg@mail.gmail.com>
Subject: Re: kvmtool (Was: Re: Linux 3.2-rc2)
From: Pekka Enberg <penberg@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 5:36 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> That is true (see http://neuling.org/linux-next-size.html).  However,
> linux-next "bottomed out" with >1500 (non-merge) commits still in it.  Of
> those, 900 are from the kvmtool tree,  So, has there been any decision
> about whether kvmtool will ever be included in the upstream tree?
>
> I do not want to reinflame the discussion and am happy to carry it along
> (it doesn't really interact with the rest of the tree), but if it is
> never going to be merged, then I may as well drop it.

There hasn't been a decision either way and we will certainly try
again in the next merge window. I think it's best to keep it in
linux-next.

                        Pekka
