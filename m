Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1DFTze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:55:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60453
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455Ab1DFTzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:55:33 -0400
Date: Wed, 06 Apr 2011 12:54:56 -0700 (PDT)
Message-Id: <20110406.125456.245400506.davem@davemloft.net>
To: lucian.grijincu@gmail.com
Cc: adobriyan@gmail.com, ebiederm@xmission.com, tavi@cs.pub.ro,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 03/24] sysctl: cookie: pass ctl_header_cookie to
 proc_handler
From: David Miller <davem@davemloft.net>
In-Reply-To: <2c7dffeffbbb6cc768816a904a1dde2d969a1c4e.1301711868.git.lucian.grijincu@gmail.com>
References: <cover.1301711868.git.lucian.grijincu@gmail.com>
	<cover.1301711868.git.lucian.grijincu@gmail.com>
	<2c7dffeffbbb6cc768816a904a1dde2d969a1c4e.1301711868.git.lucian.grijincu@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Sat,  2 Apr 2011 04:53:17 +0200

> The bulk of this patch changes all proc_handlers in the kernel to
> receive the cookie.
> 
> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>

Since this stuff is pretty invasive outside of the networking I really
need to see two things:

1) Feedback from sysctl folks.

2) Some coordination with whoever maintains sysctl stuff so we can
   decide how to stage these changes in various maintainer trees,
   including mine.
