Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1CRBAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 21:00:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:59075 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab1CRBAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 21:00:24 -0400
Date: Fri, 18 Mar 2011 09:59:39 +0900
To: oakad@yahoo.com
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        maximlevitsky@gmail.com, James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <158286.40597.qm@web37607.mail.mud.yahoo.com>
References: <20110316153321.8345606a.akpm@linux-foundation.org>
	<158286.40597.qm@web37607.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110318095916U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 18 Mar 2011 09:59:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 23:41:13 -0700 (PDT)
Alex Dubov <oakad@yahoo.com> wrote:

> Considering the comments from Fujita and James, I suppose it will be best
> for now to fold the new sg functions into the memstick patch and
> investigate how the block layer functionality can be used to a greater
> utility at some later time.

I suspect that such 'some later time' never come (especially for old
hardware). So I would prefer to merge the properly designed driver
rather than the current hacky driver.
