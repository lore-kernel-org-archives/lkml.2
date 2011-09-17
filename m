Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1IQQtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 12:49:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47252 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1IQQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 12:49:12 -0400
Date: Sat, 17 Sep 2011 18:49:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] sys_poll: Fix negative timeout values for x86 userland on x86_64 kernels
Message-ID: <20110917164909.GG7761@one.firstfloor.org>
References: <1316262630.5814.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316262630.5814.9.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 02:30:25PM +0200, Thomas Meyer wrote:
> sizeof(int/long) differs on x86 and x86_64, so provide a compat_sys_poll().

Thanks. Looks good now.

I suspect other architectures using the compat layer need the same change
though. Perhaps send a note to linux-arch@vger.kernel.org

-Andi
