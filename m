Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347Ab2JXDbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:31:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49947 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2JXDbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:31:18 -0400
MIME-Version: 1.0
In-Reply-To: <20121024031845.GA11255@kroah.com>
References: <1351046993-2220-1-git-send-email-ming.lei@canonical.com>
	<20121024031845.GA11255@kroah.com>
Date: Wed, 24 Oct 2012 11:31:16 +0800
Message-ID: <CACVXFVNAWcNgf94mY24c7r2jwtciekz=N-Yw_PyY9-4sT+BL_Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] firmware loader: introduce kernel parameter to
 customize fw search path
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:18 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Ick, no, not another kernel boot parameter.  I would prefer the /proc/
> file solution instead, just like /proc/sys/kernel/hotplug is.

OK, got it, but we could use the module parameter(firmware_class.path
via kernel command) to customize the search path too, couldn't we?

>
> But, that really wouldn't work for boot time, so, again just like
> hotplug works, make it also a Kconfig option for those distros that
> build their own kernels and keep their firmware in odd places, or don't
> have a /lib/ directory, can override it easily.

Sound like still a solution, :-)

If you agree on module parameter, that might be more flexible, IMO


Thanks,
--
Ming Lei
