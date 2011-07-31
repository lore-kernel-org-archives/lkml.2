Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1GaXYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:24:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:53745 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1GaXYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:24:15 -0400
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
From: David Woodhouse <dwmw2@infradead.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Mon, 01 Aug 2011 00:24:10 +0100
In-Reply-To: <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
References: <1312066693.22074.50.camel@i7.infradead.org>
	 <1312066923.22074.53.camel@i7.infradead.org>
	 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
	 <1312151063.18010.25.camel@i7.infradead.org>
	 <20110731224834.GC2203@ZenIV.linux.org.uk>
	 <20110731225801.GD2203@ZenIV.linux.org.uk>
	 <1312153988.18010.39.camel@i7.infradead.org>
	 <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312154652.18010.41.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 01:17 +0200, richard -rw- weinberger wrote:
> Isn't UML on ppc broken since ages?

Since before the ppc{,64} -> powerpc merge, by the looks of it.

> As I don't have a ppc box I could never test it... 

Give SSH public key and preferred username...

-- 
dwmw2

