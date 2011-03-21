Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1CUXwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:52:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300Ab1CUXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110321230710.202271726@clark.kroah.org>
References: <20110321230732.GA26510@kroah.com> <20110321230710.202271726@clark.kroah.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Mar 2011 16:22:11 -0700
Message-ID: <AANLkTikFsGPHgx=B+ZuCjq82TgO1143rW_U5DNCQRyH-@mail.gmail.com>
Subject: Re: [10/87] Fix corrupted OSF partition table parsing
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timo Warns <warns@pre-sense.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 4:06 PM, Greg KH <gregkh@suse.de> wrote:
>
> commit 1eafbfeb7bdf59cfe173304c76188f3fd5f1fd05 upstream.

This needs commit 34d211a2d5df4984a35b18d8ccacbe1d10abb067 as well.

Maybe it's there in your list, but it hasn't arrived in my mailbox yet.

                     Linus
