Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0F2Rg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:36:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932175Ab0F2RgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <20100629145617.GG28364@laptop>
References: <20100624030212.676457061@suse.de>
	<20100624030725.885831564@suse.de>
	<20100629130214.GA21410@infradead.org>
	<20100629145617.GG28364@laptop>
Date: Tue, 29 Jun 2010 10:35:47 -0700
Message-ID: <AANLkTinCVQdekiLlU4_tRkkcSGYWV6NG7nlvTirl5xZF@mail.gmail.com>
Subject: Re: [patch 02/52] fs: fix superblock iteration race
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 7:56 AM, Nick Piggin <npiggin@suse.de> wrote:
> On Tue, Jun 29, 2010 at 09:02:14AM -0400, Christoph Hellwig wrote:
>> This should actually be on it's way to Linus for .35, shouldn't it?
>
> Yeah, I was waiting for Al to reappear, but I think this is
> probably the nicest way to solve the problem. Linus?

I'll apply it. We have a couple of oopses listed for the superblock
iterator, and I haven't heard from Al. And the patch looks obviously
fine, whether it's actually the cause of some of the bugs or not.

              Linus
