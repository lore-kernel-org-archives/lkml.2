Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0CZDz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:55:58 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36731 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0CZDz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:55:57 -0400
Date: Fri, 26 Mar 2010 03:55:48 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Christoffer Dall <christofferdall@christofferdall.dk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       containers <containers@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [C/R ARM][PATCH 3/3] c/r: ARM implementation of checkpoint/restart
Message-ID: <20100326035548.GT19308@shareable.org>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk> <1269219965-23923-4-git-send-email-christofferdall@christofferdall.dk> <20100323211843.GC19572@n2100.arm.linux.org.uk> <7d08b87d1003241348g347f092k1142318490e0bdcc@mail.gmail.com> <20100326024759.GN19308@shareable.org> <20100326030208.GA5815@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326030208.GA5815@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> FDPIC supports running the same binaries with or without MMU depending on
> your ABI, it's not really that uncommon, even if it's mostly just used
> for prototyping.

Thanks - I didn't know anyone actually did it :-)

But I can see the value for product rollouts of some binaries onto a
mixture of hardware, too.

bFLT (flat) binaries should be runnable with an MMU too.

-- Jamie
