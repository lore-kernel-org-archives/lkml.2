Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0FZOtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 10:49:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48547 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0FZOtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 10:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=H/9dO+cazUTdfGYPwFup2rIGq/+Lmk2YIWQKfYA6J2hHS0zQ5sYZ+KBSQQf2/EVSMg
         zDM93c4pJm/K/+PNj1OVs5IZHhv91iUOxyQHlYsmp5axBcai/3IRHIs2FqrvoUQHY2GK
         nSaBVEfar5OdDDJJAGQtfxRwZ3V/j/EVLQK7w=
MIME-Version: 1.0
In-Reply-To: <20100626093544.GA27715@infradead.org>
References: <20100624131455.GA10441@laptop> <7897.1277531612@jrobl> 
	<20100626093544.GA27715@infradead.org>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 26 Jun 2010 07:49:13 -0700
Message-ID: <AANLkTiljx7NzPWiiWnFznfqSX898BEyaxysJt4Fc_xKo@mail.gmail.com>
Subject: Re: [rfc] new stat*fs-like syscall?
To: Christoph Hellwig <hch@infradead.org>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 02:35, Christoph Hellwig <hch@infradead.org> wrote:
> That's really job for a pathconf system call that allows quering random
> paramters.

Linus has always objected to sysconf/pathconf-like syscalls.  If you
get it in I'm all for it.
