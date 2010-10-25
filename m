Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0JYQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:16:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab0JYQQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:16:26 -0400
MIME-Version: 1.0
In-Reply-To: <4CC5A748.6050903@zytor.com>
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com> <20101025140218.5092.74117.stgit@warthog.procyon.org.uk>
 <28707.1288018465@redhat.com> <4CC5B8D3020000780001EFB4@vpn.id2.novell.com>
 <AANLkTi=mpKRQgZp5zCoCsBtkuWHrpkOq2Zch-OOGu4CC@mail.gmail.com> <4CC5A748.6050903@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Oct 2010 09:16:00 -0700
Message-ID: <AANLkTik1HB-P0x0e8ucHz7323F-_qAzkaHrHy1Yq4qwo@mail.gmail.com>
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h numbers
 in brackets
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@novell.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 8:50 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> As such, the only options I can really think about overriding the sed
> expression for x86 or just saying gcc 2.16.90 or later is required...

gas, not gcc. But yeah, maybe we can do that. How long has this space
breakage been going on? If it's a "we got a report from this one guy"
kind of thing, then just saying "we don't support old gas versions
because they are too broken" is probably the right thing to do.

No reason to make for maintenance problems and uglier code if we can
just say "get a newer gas" to a few people. It's not like we haven't
done that with gcc and other tools too.

                       Linus
