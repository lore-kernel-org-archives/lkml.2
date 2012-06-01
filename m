Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab2FARjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:39:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39228 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab2FARjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:39:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120601165614.GJ30000@ZenIV.linux.org.uk>
References: <20120601165614.GJ30000@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Jun 2012 10:38:53 -0700
X-Google-Sender-Auth: rvarG0adYsmGgWFp_L-IUn9AbnU
Message-ID: <CA+55aFxcFKxY8f1-mQz68FX3Uax-i-FQ3Wj9=z+bUn0KxTCbHA@mail.gmail.com>
Subject: Re: [git pull] vfs.git
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 9:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> There's a trivial conflict in Documentation/filesystems/vfs.txt - two
> method prototypes added, one in mainline, one here.  With the obvious
> conflict resolution...

Actually, it's one removed in mainline, one added by your pull.

What I'd *really* like to see is a kind of summary of what this pull
does, though. Please? That way I can make the merge messages be a
whole lot more informative.

            Linus
