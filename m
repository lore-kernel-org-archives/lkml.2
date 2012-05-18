Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966763Ab2ERA2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:28:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38832 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab2ERA2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:28:06 -0400
Message-ID: <4FB59789.80601@zytor.com>
Date: Thu, 17 May 2012 17:27:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Daney <ddaney.cavm@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com> <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com> <4FB59474.2020505@zytor.com> <CA+55aFwyem9KoPMhYkE-vcaUDqgP9g7arHbmD-mMHMSKXaRBOw@mail.gmail.com>
In-Reply-To: <CA+55aFwyem9KoPMhYkE-vcaUDqgP9g7arHbmD-mMHMSKXaRBOw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 05:22 PM, Linus Torvalds wrote:
> 
> That's why I think it's unfixable. It started out broken, and I
> presume that 32-bit user land on a 64-bit MIPS/PPC thing either do not
> work, or there's some compat crap (like special user-land headers)
> fixing things up. Or they just don't use that buggered msqid64_ds
> thing at all.
> 

I guess we need to find out what mips, ppc, sparc etc. do and if they
have something which works in userland make sure that it gets exported
accordingly, if they don't, then well... nothing we can do :-/

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

