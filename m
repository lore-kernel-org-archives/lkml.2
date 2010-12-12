Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0LLX6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:58:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53525 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab0LLX55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:57:57 -0500
Date: Mon, 13 Dec 2010 00:57:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Richard Weinberger <richard@nod.at>
Cc: Andi Kleen <andi@firstfloor.org>, toralf.foerster@gmx.de, hch@lst.de,
        viro@zeniv.linux.org.uk, jdike@addtoit.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [64/223] hostfs: fix UML crash: remove f_spare from hostfs
Message-ID: <20101212235756.GA21492@one.firstfloor.org>
References: <201012131244.547034648@firstfloor.org> <20101212234602.5DAB5B27BF@basil.firstfloor.org> <201012130051.55692.richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012130051.55692.richard@nod.at>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 12:51:55AM +0100, Richard Weinberger wrote:
> Andi,
> 
> Am Montag 13 Dezember 2010, 00:46:02 schrieb Andi Kleen:
> > 2.6.35-longterm review patch.  If anyone has any objections, please let me
> > know.
> 
> This patch is not needed on 2.6.35.
> It makes only sense on >= 2.6.36.

Dropped. Thanks.

-Andi
