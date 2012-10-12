Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2JLRum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab2JLRuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:50:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAMuHMdXYg+GGHwpYZmVff79SU_MhX+uiLtbmY5UH+BObiHvrXw@mail.gmail.com>
References: <CAMuHMdXYg+GGHwpYZmVff79SU_MhX+uiLtbmY5UH+BObiHvrXw@mail.gmail.com> <21143.1349774135@warthog.procyon.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for m68k [ver #2]
Date: Fri, 12 Oct 2012 18:50:35 +0100
Message-ID: <11258.1350064235@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> This leaves the following empty construct:
> 
>     #ifdef CONFIG_COLDFIRE
>     #else
>     #endif

Odd.  It emitted it in both headers, which it shouldn't have.

> I'll remove it in a subsequent patch.

Thanks.

David
