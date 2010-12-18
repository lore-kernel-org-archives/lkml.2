Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab0LRRUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:20:15 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:59390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab0LRRUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:20:13 -0500
Subject: Re: [PATCH 2.6.37] led_class: fix typo in blink API
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
In-Reply-To: <1290883328.3700.1.camel@jlt3.sipsolutions.net>
References: <1290883328.3700.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 18:20:10 +0100
Message-ID: <1292692810.3653.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-27 at 19:42 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When I added led_blink_set I had a typo: the
> return value of the hw offload is a regular
> error code that is zero when succesful, and
> in that case software emulation should not
> be used, rather than the other way around.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> It'd be nice to get this into 2.6.37 since the patch
> that has the bug is in there. Sorry about that -- I
> had tested the software implementation extensively but
> apparently never tested the hw offload part.

Any chance of this getting in still?

johannes

