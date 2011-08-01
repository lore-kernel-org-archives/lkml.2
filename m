Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1HARXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:23:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37079 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1HARXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:23:08 -0400
Date: Mon, 1 Aug 2011 18:23:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [uml-devel] [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall
 exports, not SUBARCH_i386
Message-ID: <20110801172303.GH2203@ZenIV.linux.org.uk>
References: <1312066693.22074.50.camel@i7.infradead.org>
 <1312066923.22074.53.camel@i7.infradead.org>
 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
 <1312151063.18010.25.camel@i7.infradead.org>
 <20110731224834.GC2203@ZenIV.linux.org.uk>
 <20110731225801.GD2203@ZenIV.linux.org.uk>
 <1312153988.18010.39.camel@i7.infradead.org>
 <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
 <20110801043207.GE2203@ZenIV.linux.org.uk>
 <CAMuHMdUXZw=NO-sXLWu8TMkwE-_A_sq60KUVkYZrNFqcLOALrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUXZw=NO-sXLWu8TMkwE-_A_sq60KUVkYZrNFqcLOALrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 12:04:37PM +0200, Geert Uytterhoeven wrote:
> > Yes. ??Resurrected is not the right word here, sorry...
> 
> Oh, what a disappointment. I really hoped it was true...
> 
> BTW, how much work would it be to port UML to ARM? Would be nice-to-have on
> your Android phone, as it can provide a full Linux userspace without
> requiring rooting
> the phone.

Moderately unpleasant, but not fatally so.  I have no idea how often will
cache aliasing bite you, though.  We really need to get non-x86 ports
working to see how many portability issues are there; what I've got for
ppc is promising, but very preliminary...
