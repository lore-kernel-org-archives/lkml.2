Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1GOReF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:34:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482Ab1GOReD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1107132351390.22281@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107110000280.2818@swampdragon.chaosbits.net> <alpine.LNX.2.00.1107132351390.22281@swampdragon.chaosbits.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Jul 2011 10:33:07 -0700
Message-ID: <CA+55aFycfQ7W8gST=toEySX=2-Baoo94QLS+YWFg8HVz0c7F3Q@mail.gmail.com>
Subject: Re: Should SUBLEVEL be removed for 3.x ?
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 2:53 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> Would be nice to get this clarified before 3.0 happens :-)

I don't think I can realistically make it call itself 3.0, even though
the *tag* will certainly be just 3.0.

I considered making it a config option (so that people with fixed
tools could do it), but ..

              Linus
