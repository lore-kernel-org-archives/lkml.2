Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2BWCz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 21:55:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53679 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2BWCzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 21:55:55 -0500
MIME-Version: 1.0
In-Reply-To: <6e9d38ffcb1a66f62a335450d4722809@buro.asia>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <4F456D8F.1080801@zytor.com> <CA+55aFw4P1qUye5YOJKSQHX+TfxbEDWMF7LPogj128b6gv2Nqg@mail.gmail.com>
 <CA+55aFziJ=Lw0KxxThwfqRPR+K0OWDorKAfkgKMGPXv5O404JA@mail.gmail.com>
 <4F4584EB.9060605@zytor.com> <CA+55aFxC6JwWsNcmkQ+DROXtWCzaq52DuX5aMJZfXMLoNCbsWg@mail.gmail.com>
 <20120223003706.GA3246@kroah.com> <6e9d38ffcb1a66f62a335450d4722809@buro.asia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 18:55:34 -0800
X-Google-Sender-Auth: JsQlxZfNEheVfTRmGAJdQJUIPMo
Message-ID: <CA+55aFxTieMqacU9LN8Xmtb3Os8zkub1P+SKpqFtEBQ11STy7g@mail.gmail.com>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
To: raphael@buro.asia
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 5:47 PM,  <raphael@buro.asia> wrote:
>
> Thank you for backporting this patchset to -stable. FWIW, the test machine I
> had been working with has an uptime of 4 days now, with the patchset in
> attachment applied on top of 3.2.6, so if it were unpractical to trim it
> down further you can find solace in that it does not break anything.

Hmm. The patches in your attachements are whitespace-damaged. I was
going to apply that series and see what the difference was to my
minimal trial, but with the corruption that isn't possible.

I didn't find anything obviously wrong in my series, so..

Could you send the patches you used for your backport with the
whitespace fixed, and preferably with the patch numbering explained?

                   Linus
