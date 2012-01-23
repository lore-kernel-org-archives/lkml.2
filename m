Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2AWRcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:32:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2AWRcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:32:08 -0500
Date: Mon, 23 Jan 2012 09:31:00 -0800
From: Greg KH <gregkh@suse.de>
To: Dima Zavin <dima@android.com>
Cc: Kashyap Gada <gada.kashyap@gmail.com>, rebecca@android.com,
        rschultz@google.com, jgennis@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: android: Add KERN_ facility level in printk
 () in pmem.c
Message-ID: <20120123173100.GA26943@suse.de>
References: <1327116249-18274-1-git-send-email-gada.kashyap@gmail.com>
 <CAPz4a6AUAMxcMkVkgc9UJ1tok36jNE5hZzJc_9n5EJqRQCcz2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPz4a6AUAMxcMkVkgc9UJ1tok36jNE5hZzJc_9n5EJqRQCcz2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 09:22:27AM -0800, Dima Zavin wrote:
> We really should just get rid of pmem.c altogether. We will remove it
> from our android common tree too. We don't actually use it anymore in
> any of our products. There are some legacy users of it, like Qualcomm,
> but I'm sure they have a bunch of patches on top of it and thus are
> maintaining it separately anyway.

Ok, I'll be glad to drop it if you all don't use it anymore and it's not
needed.  That makes life a lot easier for me :)

thanks,

greg k-h
