Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab0IQUhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:37:32 -0400
Received: from www.tglx.de ([62.245.132.106]:35463 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab0IQUhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:37:31 -0400
Date: Fri, 17 Sep 2010 22:37:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uio: Statically allocate uio_class and use class
 .dev_attrs.
In-Reply-To: <m18w34891v.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1009172237080.2416@localhost6.localdomain6>
References: <m1y6b48973.fsf@fess.ebiederm.org> <m18w34891v.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Eric W. Biederman wrote:
> 
> Instead of adding uio class attributes manually after the uio device has
> been created and we have sent a uevent to userspace, use the class
> attribute mechanism.  This removes races and makes the code simpler.
> 
> At the same time don't bother to dynamically allocate a struct class for
> uio, just declare one statically.  Less code is needed and it is easier
> to set the class parameters.tune the class
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
