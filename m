Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2FLJTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:19:14 -0400
Received: from ozlabs.org ([203.10.76.45]:45847 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab2FLJTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:19:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Felipe Balbi <balbi@ti.com>, trivial@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: treewide: remove extra semicolon added by module_init/exit
In-Reply-To: <20120611142028.380c5a61@nehalam.linuxnetplumber.net>
References: <1338990069-6627-1-git-send-email-balbi@ti.com> <20120606083119.0d0a0029@nehalam.linuxnetplumber.net> <87zk8bhfds.fsf@rustcorp.com.au> <20120611142028.380c5a61@nehalam.linuxnetplumber.net>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 12 Jun 2012 09:56:36 +0930
Message-ID: <87zk89nznn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 14:20:28 -0700, Stephen Hemminger <shemminger@vyatta.com> wrote:
> Given common kernel practice and the fact that only 16% of the uses of
> module_init/exit are without semicolon and that other kernel macros don't
> include semicolon.
> 
> I recommend going with the majority and common practice...
>   1. Fix the 636 places that use module_init()/exit without semicolon to include semicolon
>   2. Remove semicolon from module_init()/exit()

Um, yes.  He should do exactly what he did.

It's a wart, let's fix it.

Thanks,
Rusty.
PS. CC's chopped; somewhere in there is a bad address...
