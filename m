Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2CXSny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 14:43:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44257 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2CXSnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 14:43:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120324135647.GA5923@phenom.dumpdata.com>
References: <20120324135647.GA5923@phenom.dumpdata.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Mar 2012 11:43:31 -0700
X-Google-Sender-Auth: F-IZ1rSGAUk67jaQQxyZ0Nu4lNg
Message-ID: <CA+55aFzOhg8YVJR8N1n8xa2_TDaqoSt5Dk10RmviiGLXbba3-A@mail.gmail.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.4-tag-two (or three depending
 on your taste) for v3.4-rc0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 6:56 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> So the problem is when I do the git pull against your latest, it doesn't apply  the "provide .."
> but I still see it in the git shortlog!? Is that OK?

The fact that you see it in the shortlog just means that the commit is
there. If you don't see it in the diff, it is because somebody else
applied the *same* patch, but as a separate commit, so the merge will
have just considered it a no-op.

It's not uncommon, and if it happens occasionally with duplicated
patches that's fine. If it happens a *lot* that two people keep
applying the same patch to their different branches, that implies that
there's some workflow problem where people continually keep on
stepping on each others toes, and that's a problem.

But the occasional "oops, that change was already in mainline" is fine.

                         Linus
