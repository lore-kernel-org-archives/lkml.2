Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0GFCkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:40:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:33041 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab0GFCko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:40:44 -0400
Date: Tue, 6 Jul 2010 11:40:39 +0900
To: axboe@kernel.dk
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove unused REQ_TYPE_LINUX_BLOCK
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C31BF4C.7060205@kernel.dk>
References: <20100705181100B.fujita.tomonori@lab.ntt.co.jp>
	<4C31BF4C.7060205@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100706111816T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Jul 2010 11:40:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jul 2010 13:17:32 +0200
Jens Axboe <axboe@kernel.dk> wrote:

> On 2010-07-05 11:11, FUJITA Tomonori wrote:
> > You prefer to keep this for future possible users?
> 
> No, lets just kill it if there are no users left. We can
> always resurrect something like this later, if we want to.

Cool, please apply the patch then.
