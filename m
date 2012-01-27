Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2A0Rvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:51:41 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:46913 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2A0Rvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:51:40 -0500
Subject: Re: [PATCH 5/5] Staging: android: Add KERN_ facility level in
 printk () in pmem.c
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Greg KH <gregkh@suse.de>
Cc: Dima Zavin <dima@android.com>, Kashyap Gada <gada.kashyap@gmail.com>,
        rebecca@android.com, rschultz@google.com, jgennis@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120123173100.GA26943@suse.de>
References: <1327116249-18274-1-git-send-email-gada.kashyap@gmail.com>
	 <CAPz4a6AUAMxcMkVkgc9UJ1tok36jNE5hZzJc_9n5EJqRQCcz2w@mail.gmail.com>
	 <20120123173100.GA26943@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Jan 2012 10:51:33 -0700
Message-ID: <1327686693.3077.12.camel@lorien.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 09:31 -0800, Greg KH wrote:
> On Mon, Jan 23, 2012 at 09:22:27AM -0800, Dima Zavin wrote:
> > We really should just get rid of pmem.c altogether. We will remove it
> > from our android common tree too. We don't actually use it anymore in
> > any of our products. There are some legacy users of it, like Qualcomm,
> > but I'm sure they have a bunch of patches on top of it and thus are
> > maintaining it separately anyway.
> 
> Ok, I'll be glad to drop it if you all don't use it anymore and it's not
> needed.  That makes life a lot easier for me :)
> 
> thanks,
> 
> greg k-h

Done. I sent a patch to remove pmem driver yesterday.

https://lkml.org/lkml/2012/1/26/368

Thanks,
-- Shuah
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


