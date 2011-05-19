Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1ESEQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:16:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1ESEQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:16:42 -0400
Date: Thu, 19 May 2011 00:16:06 -0400 (EDT)
Message-Id: <20110519.001606.676062526002188941.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTikRjqpxRKKhawcD1WjyhmH1PUgz5A@mail.gmail.com>
References: <1305777978.7481.37.camel@pasglop>
	<BANLkTikRjqpxRKKhawcD1WjyhmH1PUgz5A@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 21:16:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 May 2011 21:11:47 -0700

> On Wed, May 18, 2011 at 9:06 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>>
>> Dunno if it's too late or not yet but here's 3 fixes for powerpc that
>> would be welcome to have in before the release. If not I'll send them
>> first thing next (one of them is already in -next in fact).
> 
> Gah. I just cut 2.6.39.

I know we can't let these things go forever, but in my opinion
we should have given this one or two more -rc's.
