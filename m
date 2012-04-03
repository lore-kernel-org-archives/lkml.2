Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2DCWEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:04:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38760 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DCWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:04:21 -0400
Date: Tue, 03 Apr 2012 18:02:12 -0400 (EDT)
Message-Id: <20120403.180212.1644422418766062447.davem@davemloft.net>
To: kaffeemonster@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, matt@ozlabs.org, eric.dumazet@gmail.com
Subject: Re: [REGRESSION][PATCH V4 1/3] bpf jit: Make the
 filter.c::__load_pointer helper non-static for the jits
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F75CC63.10405@googlemail.com>
References: <4F75CA89.4010709@googlemail.com>
	<4F75CC63.10405@googlemail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 15:02:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Seiffert <kaffeemonster@googlemail.com>
Date: Fri, 30 Mar 2012 17:08:19 +0200

> The function is renamed to make it a little more clear what it does.
> It is not added to any .h because it is not for general consumption, only for
> bpf internal use (and so by the jits).
> 
> Signed-of-by: Jan Seiffert <kaffeemonster@googlemail.com>

Applied but with comment formatting fixed up:

> +/*
> + * No hurry in this branch
> + *
> + * Exported for the bpf jit load helper.
> + */

Like this:

> +/* No hurry in this branch
> + *
> + * Exported for the bpf jit load helper.
> + */
