Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab2J2Vvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:51:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60283 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986Ab2J2Vvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:51:37 -0400
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
In-Reply-To: <20121028225109.GA6931@thunk.org>
References: <015201cdb54f$844487e0$8ccd97a0$@lucidpixels.com>
	<20121028225109.GA6931@thunk.org>
Date: Mon, 29 Oct 2012 17:51:37 -0400
Message-ID: <CAO9zADx=DHHDcj3by9RSMatN4RFOQLzWwPJCZzs=NemQ4_sOUQ@mail.gmail.com>
Subject: Re: 3.6.0 ext4 dump/filemap_fault?
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Justin Piszcz <jpiszcz@lucidpixels.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 6:51 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Oct 28, 2012 at 05:02:17PM -0400, Justin Piszcz wrote:
>> Hello,
>>
>> Any idea what happened here (during a backup)?
>
> A sync system call took longer than two mintues.  Why that happened,
> it's harder to say.  It's a warning, though, and not a fatal panic or
> kernel oops.
Ah, got it.

>
> How much memory do you have in your system?
32GB memory/32GB swap

> What happened afterwards?
It did eventually complete.

> Did the system continue, and did the sync command (I presume you ran
> "sync" from the command line?)  finally return to the command prompt?
In this case I did not run sync, I waited for the processes/dump/etc
to complete.

Thanks.

Justin.
