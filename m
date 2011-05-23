Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1EWPEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:04:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35158 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab1EWPET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nwFBsexnDmOWHjjKYkdImys2ehA9zPrR+9UirQbsR5/TfxHOGF9WcLTQkFDMuzFBGc
         qKQ3xcmXABhyl8RbayjJN7uwEekcQq91eQiU1SLhrmCcWtQgQ4gY6J1V4fyJbAujkLr2
         Nec8jSKe1VSR4Y+9QC8CjUyL6hDur7HcKOXTk=
MIME-Version: 1.0
In-Reply-To: <20110523135314.896139545@goodmis.org>
References: <20110523135120.309567301@goodmis.org>
	<20110523135314.896139545@goodmis.org>
Date: Mon, 23 May 2011 17:04:17 +0200
X-Google-Sender-Auth: bVOo7sR72YSHUzVSjSx69ZSEOME
Message-ID: <BANLkTimtR=_X=4hWgagtRiawHH_59V7PVQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] ktest: Reboot to good kernel after every bisect run
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 3:51 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> Reboot after each bisect run regardless if the bisect passed
> or failed. The test may just be to boot the kernel and that kernel
> may not have a way to copy the next kerne to it. Reboot to a known
> good kernel after each bisect run.
>

How about an option to not reboot for good kernels?
