Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab2DBJ4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:56:30 -0400
Received: from cet.com.ru ([195.178.208.66]:44491 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751075Ab2DBJ43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:56:29 -0400
Date: Mon, 2 Apr 2012 13:56:26 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH] w1: fix slave driver registration error message
Message-ID: <20120402095626.GA27407@ioremap.net>
References: <1333345342-12113-1-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333345342-12113-1-git-send-email-mad_soft@inbox.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 09:42:22AM +0400, Dmitry Artamonow (mad_soft@inbox.ru) wrote:
> W1 core prints "Failed to register master driver" if error happens
> on registering SLAVE driver. Fix it.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Patch looks good, thank you
Greg, please pull it into your tree if Jiri will not pick it into
trivial@

-- 
	Evgeniy Polyakov
