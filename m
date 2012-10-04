Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2JDJtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:49:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2JDJto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:49:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFzuHdT5NLGTd-+2hPvV4uzWxT+dTFZ5kCrWS+8-1zDtOA@mail.gmail.com>
References: <CA+55aFzuHdT5NLGTd-+2hPvV4uzWxT+dTFZ5kCrWS+8-1zDtOA@mail.gmail.com> <alpine.DEB.2.00.1210040456090.3115@skynet.skynet.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm merge for rc1 (part 1)
Date: Thu, 04 Oct 2012 10:49:38 +0100
Message-ID: <7367.1349344178@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ok, as usual I actually wanted to do the merge myself despite the
> annoying conflicts (this *really* is the last time I will ever accept
> any header file "cleanups" - they simply aren't worth the pain).

There was a reason I asked you to pull the patches at the *end* of the merge
window, and a reason I asked you to give me a chance to regenerate the patches
before you pulled them.

Anyway, I can feed much of the main set of patches through subsystem trees now
- so thanks for that at least.

David
