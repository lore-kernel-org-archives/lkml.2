Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0IHNFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:05:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49915 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0IHNFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:05:22 -0400
Date: Wed, 8 Sep 2010 15:05:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: miaox@cn.fujitsu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and     
 functions
Message-ID: <20100908150519.2f9fe283@basil.nowhere.org>
In-Reply-To: <4C878823.60709@cn.fujitsu.com>
References: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>
	<4C878823.60709@cn.fujitsu.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Sep 2010 20:57:07 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> On Wed, 8 Sep 2010 14:19:25 +0200 (cest), Andi Kleen wrote:
> >
> >> According to the data, the length of the most copies is>=128.
> >
> > Thanks for the data. Large is easier to optimize than small, that's
> > good.
> >
> > Could you also measure how many memsets need the backwards copy?
> > (should be easy to add)
> 
> I think memset doesn't need the backwards copy.

I meant for memmove of course. Obviously memset doesn't need a backwards
copy. That was just the only thing the script didn't measure because
the original version didn't have memmove support.

Your whole thread was about making memmove faster, right?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
