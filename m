Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab2AGBfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 20:35:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54492 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124Ab2AGBfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 20:35:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120105.192833.760673635385506638.davem@davemloft.net>
References: <20120105.192833.760673635385506638.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 17:34:39 -0800
X-Google-Sender-Auth: EkMPrL9fiaUm6xGu0LkYtbvqkaI
Message-ID: <CA+55aFyk6QJib8UCtK_gWzidr8Ti1utJgHg359fkq=+GY8hbnw@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 4:28 PM, David Miller <davem@davemloft.net> wrote:
>
> Netlink socket dumping is now supported for UDP and AF_UNIX sockets
> thanks to Pavel Emelyanov.

.. and this is such a magically important feature that it has to be
enabled by default?

It's something that has never been supported before, how did it
suddenly become 'default y' after twenty years of not even being an
issue?

It's a disease, I tell you, to think that new features are important.
Stop it. Tell people you take patches from to stop it. If we haven't
needed them before, they sure as hell aren't suddenly "Say Yes if you
don't know" material.

Please fix this, but more importantly, please try to fix *people*. So
I don't have to always react to the stupid new "default y" options.

                              Linus
