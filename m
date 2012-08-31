Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2HaNXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:23:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2HaNXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:23:06 -0400
Message-ID: <5040BAB5.6000503@gmail.com>
Date: Fri, 31 Aug 2012 23:23:01 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
CC: mcgrof@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] scripts/checkpatch.pl: A small step for Linux...
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
In-Reply-To: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, the wonders of having no coffee. I only just realized that
I wrote checkpatch instead of checkincludes!

Should I resubmit this patch series, or just leave it since it's
already on the mailing list?

On 31/08/12 23:18, Cruz Julian Bishop wrote:
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

