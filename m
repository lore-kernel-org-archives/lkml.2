Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2KBUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:16:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51655 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab2KBUQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:16:27 -0400
MIME-Version: 1.0
In-Reply-To: <50932F6E.5060506@oracle.com>
References: <1351811167-14856-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFxxdFCiOHEz_xWx1vjMkpQzab_Mdmd2dweknayhVBx6kA@mail.gmail.com> <50932F6E.5060506@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Nov 2012 13:16:06 -0700
X-Google-Sender-Auth: WkSRA2oZhpenHTGKnFlf0rEtv-I
Message-ID: <CA+55aFy9QSZhFpEt=iEvYTHMGhd3ARwpHfZ+PghHNAEcP6Ko7g@mail.gmail.com>
Subject: Re: [RFC] hlist: drop the node parameter from iterators
To: Sasha Levin <sasha.levin@oracle.com>
Cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, mingo@kernel.org,
        hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        peter.senna@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 7:26 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> Here are some stats:
>
>  - Applying the patch from -next on top of your current git head
> results in 3 conflicts.
>
>  - Applying the patch from your current git head on top of v3.6 results
> in 18 conflicts.
>
>  - Applying the patch from 3.6 on top of 3.5 results in 25 conflicts.

Ok, that sounds slightly painful, but not unmanageable.

Can you send me the actual patch, and I'll mull on this a bit more? I
could run the coccinelle script myself, but I assume (maybe
incorrectly?) that there are manual fixes to clean some stuff up
afterwared..

               Linus
