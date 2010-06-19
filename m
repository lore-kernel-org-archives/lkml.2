Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0FSIvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:51:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33899 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0FSIvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:51:23 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Zhihui Zhang <zzhsuny@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: idea about internal fragmentation in Btrfs
References: <AANLkTilWguh4IrDHVgtTxjoiAeSy23SK_M1dWapgvSDt@mail.gmail.com>
Date: Sat, 19 Jun 2010 10:51:22 +0200
In-Reply-To: <AANLkTilWguh4IrDHVgtTxjoiAeSy23SK_M1dWapgvSDt@mail.gmail.com>
	(Zhihui Zhang's message of "Fri, 18 Jun 2010 14:12:22 -0400")
Message-ID: <87k4pvo16d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhihui Zhang <zzhsuny@gmail.com> writes:

> I wish Btrfs well, so I would venture an idea for this specific case
> mentioned by Edward Shishkin today.
>
> Everyone knows that B-tree has internal and leaf nodes.  Can we make
> the root as the leaf?  In other words, if you
> create a 2K file, the B-tree will have only one node, which is both
> the root and the leaf. Of course, you need some flag to
> say this is a "degenerated" form of B-tree. Please cc me if you want
> my response.

You need to copy linux-btrfs to reach btrfs developers.
Ccs added

The problem with your idea is that on btrfs there's only 
a single tree for the whole fs (or whole snapshot rather)
So it would only work for a single file because there's
only a single root.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
