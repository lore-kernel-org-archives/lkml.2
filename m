Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab1AJWwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:52:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049Ab1AJWwq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:52:46 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimHzjRLxGLabXgh7bvoD+f9jOC8CRS0YFeKzMDz@mail.gmail.com>
References: <AANLkTimHzjRLxGLabXgh7bvoD+f9jOC8CRS0YFeKzMDz@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Jan 2011 14:52:22 -0800
Message-ID: <AANLkTimsHh7gX3ECmsHYorUSwE2xRipvhixYqhnp5MR=@mail.gmail.com>
Subject: Re: [GIT PULL] ux500-core leftovers
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Rabin VINCENT <rabin.vincent@stericsson.com>,
        linux-arm-kernel@lists.infradead.org,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:00 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> Linus, could you please pull:
>
>      git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
> for-torvalds
>
> This is based on commit 0c21e3a and contains
> the following patches that couldn't be merged through
> Russell's ARM tree due to cross-branch dependencies
> now sorted out in your tree:

Please do also include a diffstat ("git diff -M --stat --summary
origin...") with the pull, so that I see what I'm pulling before I
pull, and to make it easier to verify that I'm getting what you
intend.

I pulled, but next time I might not.

              Linus
