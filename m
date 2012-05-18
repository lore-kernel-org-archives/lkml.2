Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962Ab2ERLor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab2ERLop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:44:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFx4sEQT=U4DBULeo9=3piOx_pQUws92ovKV5bKsu3hQQQ@mail.gmail.com>
References: <CA+55aFx4sEQT=U4DBULeo9=3piOx_pQUws92ovKV5bKsu3hQQQ@mail.gmail.com> <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com> <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com> <4FB59474.2020505@zytor.com> <CA+55aFwyem9KoPMhYkE-vcaUDqgP9g7arHbmD-mMHMSKXaRBOw@mail.gmail.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
Date: Fri, 18 May 2012 12:44:25 +0100
Message-ID: <29114.1337341465@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Note: totally untested. Maybe there's some reason why my anonymous
> union trick wouldn't work.

It might conceivably break a userspace compiler if it gets exported to
userspace.  I'm not sure how likely that would be, though.

David
