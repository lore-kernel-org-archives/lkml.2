Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab2IZQl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:41:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63438 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab2IZQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:41:26 -0400
Date: Wed, 26 Sep 2012 09:41:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memstick: add support for legacy memorysticks
Message-ID: <20120926164121.GQ16296@google.com>
References: <1348652941-31899-1-git-send-email-maximlevitsky@gmail.com>
 <1348652941-31899-3-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348652941-31899-3-git-send-email-maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:49:01AM +0200, Maxim Levitsky wrote:
> Based partially on MS standard spec quotes from Alex Dubov.
> 
> As any code that works with user data this driver isn't
> recommended to use to write cards that contain valuable data.
> 
> It tries its best though to avoid data corruption
> and possible damage to the card.
> 
> Tested on MS DUO 64 MB card on Ricoh R592 card reader.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Workqueue related part looks good to me.  Don't have much clue about
other stuff.

Thanks.

-- 
tejun
