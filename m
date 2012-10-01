Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2JAVtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:49:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59454 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2JAVtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:49:02 -0400
Message-ID: <506A0FCA.2020908@suse.cz>
Date: Mon, 01 Oct 2012 23:48:58 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Stanislav Kozina <skozina@redhat.com>
Subject: Re: [GIT PATCH] TTY patches for 3.7-rc1
References: <20121001183046.GA13042@kroah.com>
In-Reply-To: <20121001183046.GA13042@kroah.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 08:30 PM, Greg KH wrote:
> Stanislav Kozina (2):
>       tty: Fix possible race in n_tty_read()

The (pretty hopeless) commit log says:
    Fix possible panic caused by unlocked access to tty->read_cnt in
    while-loop condition in n_tty_read().

Just curious, what kind of panic that can cause, can you be more
concrete on that? I suppose two readers, one eats everything, the other
is a killer? And should we backport to -stable?

thanks,
-- 
js
suse labs
