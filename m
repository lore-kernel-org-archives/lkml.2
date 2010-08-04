Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab0HDRrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:47:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918Ab0HDRq7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:46:59 -0400
MIME-Version: 1.0
In-Reply-To: <20100803140855.GA26161@srcf.ucam.org>
References: <20100803140855.GA26161@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Aug 2010 10:45:41 -0700
Message-ID: <AANLkTik5eK+utozrXXH1n3-aO1wHgkzjZvHqF5TmoE=4@mail.gmail.com>
Subject: Re: [GIT PULL] x86 platform drivers for 2.6.36
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 7:08 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
>
>  Linux 2.6.35 (2010-08-01 15:11:14 -0700)
>
> are available in the git repository at:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for-linus

No, they are not. It's branch "for_linus". Tssk.

(Normally I just ignore incorrect pull requests, but I did an
"ls-remote" to see what branches you have and just fixed it up this
time. But next time I might just drop it as bogus, so you do want to
be careful)

                Linus
