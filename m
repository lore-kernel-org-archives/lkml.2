Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945964Ab2JZVWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:22:37 -0400
Received: from natasha.panasas.com ([67.152.220.90]:45124 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945930Ab2JZVWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:22:36 -0400
Message-ID: <508AFF17.6050705@panasas.com>
Date: Fri, 26 Oct 2012 14:22:31 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] VFS: add config options to enable link restrictions
References: <20121026185021.GA1960@www.outflux.net> <CA+55aFxSO9oGtNEBOAVXj+OQn0tye7rNBu8C5tsggsYdZarNrw@mail.gmail.com> <CAGXu5jL4qh5nXBJJQAr-42hZHk7bP0Gn468Sf3i8+W0eo1_LKA@mail.gmail.com> <CA+55aFzw_p-WJyBBGc5UFDU8yN698REH+Vc1fk=CDeq4JG8AFA@mail.gmail.com> <CAGXu5jKP5XxSkz48PsqbrpBZMU=wjsmq+HExZGKMOeHrB9PHrg@mail.gmail.com>
In-Reply-To: <CAGXu5jKP5XxSkz48PsqbrpBZMU=wjsmq+HExZGKMOeHrB9PHrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 01:23 PM, Kees Cook wrote:
> 
> Every distro will ship with this enabled (except perhaps Damn
> Vulnerable Linux), so why make it harder?
> 

So please remind me why can't it be on by default in code.
And the normal sysctl to turn it off for these who want to
experiment with "filesystem corruption".

So the basic premise is that you must not have any
filesystem corruption at the parts used by boot up until
the init portion that turns "filesystem corruption" on

> -Kees
> 

Cheers
Boaz
