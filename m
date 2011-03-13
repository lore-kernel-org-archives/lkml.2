Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1CMWws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 18:52:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579Ab1CMWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 18:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <4D7A33FF.80509@fusionio.com>
References: <4D7A33FF.80509@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 13 Mar 2011 15:51:56 -0700
Message-ID: <AANLkTi=NAeBWE28Vygx5Qf+OYgMW2Js180fptQnbbXmw@mail.gmail.com>
Subject: Re: [GIT PULL] Single important block patch for 2.6.38
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Czerner <lczerner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 6:38 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> This fixes a regression introduced early in the 2.6.38 series, where
> blkdev_issue_zeroout() has a nasty race that causes a panic. Thanks to
> Lukas Czerner for finding and fixing this one. Please pull!

What about the "Null pointer OOPS in sync_inodes_sb" issue due to the
broken sb->s_bdi setting to NULL?

                       Linus
