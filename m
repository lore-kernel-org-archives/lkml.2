Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1HAKlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:41:00 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45216 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1HAKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:40:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUXZw=NO-sXLWu8TMkwE-_A_sq60KUVkYZrNFqcLOALrA@mail.gmail.com>
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
Date: Mon, 1 Aug 2011 12:40:52 +0200
Message-ID: <CAFLxGvxH+O=9vxCQSgTqZgHCbO2x-dDi3YUudHpapTu1v=VN1A@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall
 exports, not SUBARCH_i386
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 12:04 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> BTW, how much work would it be to port UML to ARM? Would be nice-to-have on
> your Android phone, as it can provide a full Linux userspace without
> requiring rooting
> the phone.
>

Depends how strong your UML- and ARM-fu is. ;-)
I'm sure it will be non-trivial...

-- 
Thanks,
//richard
