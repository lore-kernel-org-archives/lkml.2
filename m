Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423327Ab2LGRb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:31:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37446 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422999Ab2LGRbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:31:24 -0500
Date: Fri, 7 Dec 2012 09:31:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 17/27] Revert "sched, autogroup: Stop going ahead if autogroup
 is disabled"
Message-ID: <20121207173117.GA18986@kroah.com>
References: <20121207005825.232489605@linuxfoundation.org>
 <20121207005830.838566702@linuxfoundation.org>
 <50C225D0.9030902@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C225D0.9030902@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 12:22:24PM -0500, Joseph Salisbury wrote:
> Will you also be including this patch in v3.5 stable?

There is no v3.5-stable kernel tree anymore, it has been end-of-life for a while.

There is a 3.5-stable tree that Canonical is doing, but no one on the
 Cc: you sent this to is in control of that one.

Sorry,

greg k-h
