Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0JUHu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:50:59 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57092 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127Ab0JUHu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:50:57 -0400
Date: Thu, 21 Oct 2010 09:50:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Chris Friesen <chris.friesen@genband.com>
Cc: netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] problems with "ip xfrm" on 32-bit userspace with 64-bit
 kernel
Message-ID: <20101021075056.GE15247@Chamillionaire.breakpoint.cc>
References: <4CBF78B6.90002@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBF78B6.90002@genband.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen <chris.friesen@genband.com> wrote:
> We've run into a 32/64 compatibility problem with iproute2.  The "ip
> xfrm monitor acquire" command doesn't work properly due to struct size
> mismatches between kernel and userspace.

Yes.  See archives for 'xfrm: add x86 CONFIG_COMPAT support'
(http://marc.info/?t=127050655600003&r=1&w=2)

for a discussion on why the patch set to fix this was rejected.
