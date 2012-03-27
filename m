Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2C0RVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:21:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57755 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab2C0RVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:21:35 -0400
Date: Tue, 27 Mar 2012 10:21:33 -0700
From: "Ted Ts'o" <tytso@mit.edu>
To: Kees Cook <keescook@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Correct way to include siginfo.h?
Message-ID: <20120327172133.GB10142@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Kees Cook <keescook@google.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <CAGXu5jK3ezCN2=hy=AARh=T9L8YzCTKAXH6dbAH7FGX3P8VkoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jK3ezCN2=hy=AARh=T9L8YzCTKAXH6dbAH7FGX3P8VkoQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 10:01:10AM -0700, Kees Cook wrote:
> 
> Does anyone know the right way to include siginfo.h when building
> userspace tools that need it?

What fields or structures are you trying to get at?  I haven't needed
to include siginfo.h explicitly even though this file pokes and prods
pretty thoroughly at the siginfo structures:

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob;f=e2fsck/sigcatcher.c;h=10b93287d5b2b4da1fb43d34fafd848d06c01645;hb=5f7c04972fefa8198c34f231a9e8a5430705b4ab

The sigcatcher.c file is a debugging tool for e2fsprogs that prints
pretty much everything that is available to userspace, as far as I
know...

						- Ted
