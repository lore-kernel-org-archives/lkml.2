Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2BHQOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:14:41 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48793 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535Ab2BHQOk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwc+VvFyv3TJgZ+wZVz738sWA+csi3_u5AeZG4AiXn82g@mail.gmail.com>
References: <CA+55aFwc+VvFyv3TJgZ+wZVz738sWA+csi3_u5AeZG4AiXn82g@mail.gmail.com>
Date: Thu, 9 Feb 2012 01:14:39 +0900
Message-ID: <CAMO-S2i8Z7q2NQN4WDwvwjrNAoe2uFKhFcfpLb4gRHoZtiynzQ@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: architecture independent readq/writeq for
 32bit environment
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Roland Dreier <roland@purestorage.com>,
        Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        James Bottomley <jbottomley@parallels.com>,
        Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>, linux-kernel@vger.kernel.org,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 12:56, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Feb 6, 2012 6:47 PM, "Hitoshi Mitake" <h.mitake@gmail.com> wrote:
>>
>>  All of them are endian aware
>
> I think that part is wrong.
>
> Pci is little-endian, so readl and writel are always already little-endian.
> Trying to make readq be endian-aware is wrong.

Is every memory area which can be read/written by read[wl]/write[wl]
always little-endian?

If so, of course I have to eliminate the big-endian version.
But I'm not sure about this point because the new readq/writeq is
in asm-generic which is used by every archs, so I'd like to ask you about it.

>
>                           Linus
>
> On Feb 6, 2012 6:47 PM, "Hitoshi Mitake" <h.mitake@gmail.com> wrote:



-- 
Hitoshi Mitake
h.mitake@gmail.com
