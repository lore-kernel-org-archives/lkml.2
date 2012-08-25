Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2HYRhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:37:34 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59331 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585Ab2HYRha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:37:30 -0400
Date: Sat, 25 Aug 2012 19:37:25 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-usb@vger.kernel.org
Subject: Re: [Patch] block: remove the deprecated ub driver
Message-ID: <20120825173725.GD3363@breakpoint.cc>
References: <1345909883-29977-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345909883-29977-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 11:51:23PM +0800, Cong Wang wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> 
> It is scheduled to be removed in 3.6.

This should go via Greg and linux-usb and you should put Pete Zaitcev on Cc.
I have a patch in my try doing this and removing the libusual which is obsolete
since there is only one driver for USB storage.
I would not remove the config option from all these defconfigs. Once this
symbol is gone, it will vanish from defconfigs all by itself once they update
their defconfigs and this patch does not clash with them.

Sebastian
