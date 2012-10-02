Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2JBQiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:38:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55907 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2JBQiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:38:06 -0400
MIME-Version: 1.0
In-Reply-To: <13458.1349122608@warthog.procyon.org.uk>
References: <13458.1349122608@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Oct 2012 09:37:44 -0700
X-Google-Sender-Auth: vI0iK_ItxiEkEOoDZn2_nhrYYbA
Message-ID: <CA+55aFyu9rJH0x9eAF7A=m64nSCRtcPxdE4MR3+ZSd8qxEbwFw@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate the User API from the kernel headers
To: David Howells <dhowells@redhat.com>
Cc: arnd@arndb.de, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
        fengguang.wu@intel.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 1:16 PM, David Howells <dhowells@redhat.com> wrote:
>
> Could you please pull this tree at the _end_ of this merge window?

At the KS you said you'd be able to split this up into a preparatory
patch. That doesn't seem to have happened.

The whole "at the end of the merge window" tends to be something I
hate doing anyway, but this merge window I'll be traveling at the end.

The whole "this pull is magical" thing just isn't working.

                 Linus
