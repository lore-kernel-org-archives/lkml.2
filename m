Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0L3RRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 12:17:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897Ab0L3RRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 12:17:53 -0500
MIME-Version: 1.0
In-Reply-To: <1293700078-5141-1-git-send-email-ngupta@vflare.org>
References: <1293700078-5141-1-git-send-email-ngupta@vflare.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Dec 2010 09:17:31 -0800
Message-ID: <AANLkTi=R0sOvSZqu+Va=W2xJMKEw+kJXufuDwNe8o5NL@mail.gmail.com>
Subject: Re: [PATCH][zram] Do not check for init flag before starting I/O
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Dennis Jansen <dennis.jansen@web.de>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 1:07 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> zram module is unusable without this fix.

.. and apparently it oopses without it.

See commit 7e24cce38a99f3 which added the code that you now remove.
You were cc'd on it, I don't think we got any reply to it.

So no. I'm not taking this without way more explanations of why the
original problem isn't a problem any more.

                            Linus
