Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1D0WRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:17:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63153 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1D0WRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mNIT2RvUtEbPMx+TZg0yfqx7CYtB5S5/zEKdf/easNweeBlkYrRkOx/Zz7BZCEZxb3
         TtyybVlHQ4VLmubZ5k/1Ibqqtef2DFQXY1XZlKYj3MSvsnjdZeAPygGZLxNewawkRroH
         39D8oy0PtnHsqlAnueI44SgXM72SFDia+St/0=
MIME-Version: 1.0
In-Reply-To: <20110427214657.GE9487@ZenIV.linux.org.uk>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<20110427164639.GD9487@ZenIV.linux.org.uk>
	<1303924079.18763.70.camel@gandalf.stny.rr.com>
	<20110427214657.GE9487@ZenIV.linux.org.uk>
Date: Wed, 27 Apr 2011 19:17:11 -0300
Message-ID: <BANLkTin_ZPDmXirK4MmmV5LaC6zmpb+qmw@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Thiago Farina <tfransosi@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 6:46 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> That's the whole fucking _point_; adding random extensions to the language
> leads to the place where Pascal and LISP are and it's not pretty.  Each
> might make sense taken separately (hell, bzero(3) would prevent real, honest
> to Cthulhu bugs - it's memset(p, 0, n) and we had memset-with-swapped-arguments
> bugs fairly often and yes, in our tree most of memset() callers do pass '\0'
> as the second argument).  Pile enough of those together and you've got yourself
> a dialect only you understand.  _Bad_ idea, since the next thing that happens
> is different dialects in different parts of tree.  And the end of non-incestous
> code review and fixes.  I've seen it first-hand (OK, second - I had enough
> sense to stay out of that particular clusterfuck) on Algol 68 codebase.  I
> *really*, *really* do not want to see anything similar ever again.  Especially
> on projects I can't just piss upon and walk away from.  The fact that in C
> you *can* extend the language that way doesn't make it a good idea.
>
> While we are at it, strcmp() is, indeed, a part of the language.

Part of the C standard library you mean, no?

> See
> section 7.21.4.2 in C99.
>
