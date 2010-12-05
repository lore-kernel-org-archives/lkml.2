Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0LESHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 13:07:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715Ab0LESHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 13:07:40 -0500
MIME-Version: 1.0
In-Reply-To: <m1oc90n6qp.fsf@fess.ebiederm.org>
References: <m1oc90n6qp.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 Dec 2010 10:06:57 -0800
Message-ID: <AANLkTikCXV_y2fmv0wTPXvxEad3Sqs_Vr4S+6_pZFDoo@mail.gmail.com>
Subject: Re: [PATCH]: Revert 2.6.36 chroot ttyname regression
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 9:11 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> As of 2.6.36 ttyname does not work in a chroot.

I'll happily revert, but even for trivial stuff like this I'd like to
get the sign-off, just so that we always have it.

                    Linus
