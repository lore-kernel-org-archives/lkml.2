Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1APSvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:51:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab1APSvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:51:07 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinVDdUX70E12fqJBBsd+zKDF4zpnG4YSUhCuQCD@mail.gmail.com>
References: <AANLkTimBXn8zoQdPE0t-P5FZ_rLi+1jzuzG+WxeiCwFD@mail.gmail.com>
 <AANLkTim6u9WUE7RkXUYEbTqftZ8gmB1xTYD_H8c7yhpu@mail.gmail.com> <AANLkTinVDdUX70E12fqJBBsd+zKDF4zpnG4YSUhCuQCD@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jan 2011 10:50:46 -0800
Message-ID: <AANLkTincccrgVmFqNPOr9HYipsJMMSSyDW9r9YGe01F7@mail.gmail.com>
Subject: Re: Please revert nouveau.
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 10:31 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>
> This is not new: https://lkml.org/lkml/2010/12/31/37
> And the bisect is really hard.

So?

If you can't do a good report, why do you expect anybody to do
anything about it? I certainly can't just revert everything, based on
basically zero information.

You can't even tell why the bisect is so magically hard. Why is it
hard? What's so hard about "it works" vs "it doesn't work"? You give
no information about that _either_.

In other words, the onus is really on _you_ to give way better
information. "It doesn't work" isn't worth much, and will always be
ignored by developers.

                          Linus
