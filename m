Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1LVU7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:59:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64454 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab1LVU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:59:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111222202017.GA13208@havoc.gtf.org>
References: <20111222202017.GA13208@havoc.gtf.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Dec 2011 12:59:14 -0800
X-Google-Sender-Auth: YfM0Fue2dvmkklnq3EJMblLBNOw
Message-ID: <CA+55aFycz+kScx671vQaLyHz6jyQUJ_ZB6MYx1scdHjX29R_0Q@mail.gmail.com>
Subject: Re: [git patch] libata build fix for 3.2-rc
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 12:20 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> A sparc build fix...

Pulled..

> -----BEGIN PGP SIGNED MESSAGE-----

And these days it would actually be better if you just use git signed
tags instead, and ask me to pull them. You don't need to do anything
special per se (just "git tag -s" to create the signature, and then
"git push -tags" to push it out), it's only the merger who has to then
have a recent enough git version that pulling the tag will DTRT. And I
do.

So then you don't need to do this send-time PGP signature, and git
will now verify (and save) the signature automatically.

See
  https://lkml.org/lkml/2011/12/14/543

that I sent to Ted about how it ends up looking - you can check out
that commit 2240a7bb479c with "git show" and "git cat-file commit" to
see how your signature would be archived and saved without actually
being bothersome when just looking at the history.

                  Linus
