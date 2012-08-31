Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2HaSK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:10:26 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:23590 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2HaSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:09:52 -0400
Date: Fri, 31 Aug 2012 20:09:48 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
cc: mcgrof@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] scripts/checkpatch.pl: A small step for Linux...
In-Reply-To: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
Message-ID: <alpine.LNX.2.00.1208312008210.14761@swampdragon.chaosbits.net>
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2012, Cruz Julian Bishop wrote:

> ...and a big step for learning more Perl.
> 
> Hi!
> 
> This patch set started off as an experiment, but as I continued, I
> realised that I should submit this and see if it's suitable for merging
> into Linux.
> 
> To start off with, here's some patches for checkincludes.pl
> 
> This set was created for the following purposes:
> 
>     1: Making it slightly easier to read
>     2: Making it easier to extend and add new arguments
>     3: Changing the usage output to look more "correct"
>     4: Introducing a 'quiet' mode like checkpatch.pl, and printing
>         messages for files without duplicated includes by default
>        
> Sorry if I did anything wrong - It's my first time really
> experimenting with Perl. 
> 
> Thanks in advance.
> 
> ~Cruz
> 
> Cruz Julian Bishop (4):
>   scripts/checkincludes.pl: Print usage with heredoc
>   scripts/checkincludes.pl: Simplify and shorten argument logic
>   scripts/checkincludes.pl: Fix a bug introduced in the last commit
>   scripts/checkincludes.pl: Introduce 'quiet' mode
> 
>  scripts/checkincludes.pl |  113 ++++++++++++++++++++++++++--------------------
>  1 file changed, 65 insertions(+), 48 deletions(-)
> 
> 
Minor detail. Your patches are for "scripts/checkincludes.pl" but the 
subject says "scripts/checkpatch.pl"... You may want to get it straight 
what you are patching and let the subject reflect reality :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

