Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0JNMzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:55:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48735 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0JNMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:55:24 -0400
Date: Thu, 14 Oct 2010 14:55:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
Message-ID: <20101014125519.GB13414@basil.fritz.box>
References: <87sk0a1sq0.fsf@basil.nowhere.org>
 <20101014160217N.fujita.tomonori@lab.ntt.co.jp>
 <20101014072421.GA13414@basil.fritz.box>
 <20101014173103U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014173103U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that at least one mainline driver in arm uses such trick but I
> can't recall the name. Better to ask on the arm mainling list. Also I
> heard that the are some out-of-tree patches about this.

I'm sure there are out of tree patches for lots of things,
but at least in terms of merging mainline functionality
use cases merged in the mainline tree are required.

-Andi
