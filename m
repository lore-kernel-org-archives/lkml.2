Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab1EXWN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:13:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756354Ab1EXWN0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110524152304.GB5390@quack.suse.cz>
References: <20110524152304.GB5390@quack.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2011 15:13:02 -0700
Message-ID: <BANLkTikun0+8bdhJ+-grLF04xuNEhKnjOg@mail.gmail.com>
Subject: Re: [PULL REQUEST] Ext2 & ext3 fixes for 2.6.40-rc1
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 8:23 AM, Jan Kara <jack@suse.cz> wrote:
>
>  could you please pull from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/fs.git for_linus

Grr.

That tree doesn't exist.

You meant

  git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6 for_linus

didn't you?

Please fix your scripts.

                         Linus
