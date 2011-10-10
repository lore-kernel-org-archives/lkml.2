Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1JJKYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:24:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40153 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJKYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	<cover.1318233879.git.joe@perches.com>
Date: Mon, 10 Oct 2011 19:24:32 +0900
Message-ID: <CAKYAXd_7hN_z6pPA14JYe+Q_cpRf_ZHvGNXUhhiXTYmruN8LPw@mail.gmail.com>
Subject: Re: [PATCH 0/6] udf: Change some KERN_<level>s and logging neatening
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/10 Joe Perches <joe@perches.com>:
> I reviewed your patch and think it's too large
> for others to review because it combines multiple
> things into a single patch.
>
> I think that adding struct super_block * to udb_debug
> isn't necessary or particularly useful.
>
> Here are the changes to your original patch that I made:
>
> Separate a single large patch into reviewable chunks.
> Don't convert every message type to udf_<foo>.
Hi Joe.
Thank you, you are given a nice clean up.
>
> Joe Perches (6):
>  udf: Promote some debugging messages to udf_error
>  udf: Rename udf_error to udf_err
>  udf: Rename udf_warn to udf_warn
>  udf: Convert printks to pr_<level>
>  udf: Neaten logging output, use vsprintf extension %pV
>  udf: Neaten udf_debug uses
>
>  fs/udf/balloc.c    |   14 ++--
>  fs/udf/directory.c |    8 +-
>  fs/udf/inode.c     |   36 ++++-----
>  fs/udf/lowlevel.c  |    2 +-
>  fs/udf/misc.c      |   24 ++++---
>  fs/udf/namei.c     |    5 +-
>  fs/udf/partition.c |   11 +--
>  fs/udf/super.c     |  214 +++++++++++++++++++++++-----------------------------
>  fs/udf/truncate.c  |   21 ++---
>  fs/udf/udfdecl.h   |   35 ++++++---
>  fs/udf/udftime.c   |    3 +-
>  fs/udf/unicode.c   |    6 +-
>  12 files changed, 178 insertions(+), 201 deletions(-)
>
> --
> 1.7.6.405.gc1be0
>
>
