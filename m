Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0IPKLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 06:11:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41133 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0IPKLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 06:11:47 -0400
Date: Thu, 16 Sep 2010 12:11:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: miaox@cn.fujitsu.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Message-ID: <20100916121141.6eb95a22@basil.nowhere.org>
In-Reply-To: <4C91E37C.2060309@cn.fujitsu.com>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
	<4C91C44F.40700@cn.fujitsu.com>
	<20100916104008.3e1e34b2@basil.nowhere.org>
	<4C91E37C.2060309@cn.fujitsu.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 17:29:32 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:


Ok was a very broken patch. Sorry should have really done some more
work on it. Anyways hopefully the corrected version is good for
testing.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
