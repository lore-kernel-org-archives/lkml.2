Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1JQVyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:54:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1JQVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:54:12 -0400
Date: Mon, 17 Oct 2011 17:51:41 -0400 (EDT)
Message-Id: <20111017.175141.1489173261757833533.davem@davemloft.net>
To: dpmcgee@gmail.com
Cc: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/mm: remove hack in mmap randomize layout
From: David Miller <davem@davemloft.net>
In-Reply-To: <1318882661-26859-1-git-send-email-dpmcgee@gmail.com>
References: <1318882661-26859-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 17 Oct 2011 14:51:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan McGee <dpmcgee@gmail.com>
Date: Mon, 17 Oct 2011 15:17:36 -0500

> Since commit 8a0a9bd4db63bc45e301, this comment in mmap_rnd() does not
> hold true as the value returned by get_random_int() will in fact be
> different every single call. Remove the comment and simplify the code
> back to its original desired form.
> 
> This reverts commit a5adc91a4b44b5d1 which is no longer necessary.
> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>

Can you please fix up all the other architectures which use the same
logic, because they have simply copied over what powerpc does?

At a minimum, Sparc has two such locations.
