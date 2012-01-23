Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2AWXOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:14:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62981 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2AWXOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:14:44 -0500
MIME-Version: 1.0
In-Reply-To: <201201232244.19379.rjw@sisk.pl>
References: <201201232244.19379.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 15:14:22 -0800
X-Google-Sender-Auth: 4ilrEusQZls1FtUwY4_6c5wko0M
Message-ID: <CA+55aFyDo34V5qtFPq5XQgZicFOeU7t6eEzuvbx20FS2+CwCNw@mail.gmail.com>
Subject: Re: [GIT PULL] Power management fixes for 3.3
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 1:44 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> (this actually is a signed tag, which I've tried to use for the first time
> ever, but hopefully it's OK).

Looks fine. In the future, I'd suggest not adding things that are
computable to the tag message (ie shortlog and diffstat). They don't
really add any new information, unlike your own commentary.

I edited those parts out from the merge message (it's still accessible
in the hidden tag information, of course, since the tag message is
part of what gets covered by the signature).

                  Linus
