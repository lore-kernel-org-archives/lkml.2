Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab2BMW3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:29:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41876 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2BMW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:29:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120213201522.GA23907@oksana.dev.rtsoft.ru>
References: <20120213201522.GA23907@oksana.dev.rtsoft.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Feb 2012 14:29:00 -0800
X-Google-Sender-Auth: XtCteyp8VO7aTX3Za1MFbTSfNYI
Message-ID: <CA+55aFyT3NAaOFB7UyaJMDX0U-GzZgqJe1a_wPrgmn6TO0=8WQ@mail.gmail.com>
Subject: Re: [GIT PULL] battery-urgent.git
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 12:15 PM, Anton Vorontsov
<cbouatmailru@gmail.com> wrote:
>
> Let's try requesting pull via the signed tag thing...

Well, it works, but your key currently isn't signed by *anybody*, so
right now it is a bit pointless.

That said, if you get it signed by more people in the future, the
signature that stays around in the kernel will become more meaningful
than it is today.

Qnd even in the absence of that, any future pushes using the same key
will obviously show that the git tree is controlled by somebody who
has access to that same key. So a gpg signature has *some* meaning
even when there is no external sign of trust, but it really is not
nearly as meaningful as it could be.

I don't know where you are physically, but we've got a fairly
geographically wide set of keys these days, so I think it should be
possible to get that key signed by some relevant people.. Hmm?

                   Linus
