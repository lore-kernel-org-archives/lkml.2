Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2CaTsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:48:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43238 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2CaTsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120331193913.GX6589@ZenIV.linux.org.uk>
References: <20120331051906.GU6589@ZenIV.linux.org.uk> <CA+55aFxmOEUCXeHtSAN+g3cSpFVvf5vPTSzZDtXdJs0Hq1rVZw@mail.gmail.com>
 <CA+55aFztRQHX+3KET_xdQd9TuEEuuGS6ogrKAEYGaWfd6m9rDA@mail.gmail.com>
 <20120331185738.GW6589@ZenIV.linux.org.uk> <CA+55aFxtN9j5j6XC9nDf+mNJ06ipgD4cbW6hrZw6+3KfvDSuww@mail.gmail.com>
 <20120331193913.GX6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Mar 2012 12:48:22 -0700
X-Google-Sender-Auth: 2QLYB_B4pOqI3TQ5uahf1SxsMGg
Message-ID: <CA+55aFwbHtLuo4yuDnWO-UgH5p7JThhG6uppX9hvQAXic9MS2w@mail.gmail.com>
Subject: Re: [git pull] vfs part 2
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 12:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Variants:
>        1) drop that commit, fold obvious fix into it, leave it for for-next
> once -rc1 is there; ask you to pull the branch with that sucker excluded
>        2) fold the fix into commit, ask you to pull the resulting branch
>        3) add fix to the end of existing branch, ask to pull

Let's go for (2). I'll take a new look after the pull request, but no
guarantees that I'll then pull it.

Btw, I liked the do_lookup cleanups, but nicer commit logs would have
been good. Especially the first lines. The whole

     untangling do_lookup(), part 1
     untangling do_lookup(), part 2
     untangling do_lookup(), part 3
     untangling do_lookup(), part 4
     untangling do_lookup(), part 5
     untangling do_lookup(), part 6
     untangling do_lookup(), part 7
     untangling do_lookup(), part 8
     untangling do_lookup(), part 9

in shortlogs (and gitk!) does turn me off. So since you have to redo
the series anyway, can I ask you to perhaps try to make it a bit more
descriptive?

                       Linus
