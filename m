Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0IQU5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:57:43 -0400
Received: from www.tglx.de ([62.245.132.106]:46252 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0IQU5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:57:42 -0400
Date: Fri, 17 Sep 2010 22:57:37 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uio: Statically allocate uio_class and use class
 .dev_attrs.
Message-ID: <20100917205737.GE2522@local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <m18w34891v.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009172237080.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009172237080.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:37:26PM +0200, Thomas Gleixner wrote:
> On Tue, 14 Sep 2010, Eric W. Biederman wrote:
> > 
> > Instead of adding uio class attributes manually after the uio device has
> > been created and we have sent a uevent to userspace, use the class
> > attribute mechanism.  This removes races and makes the code simpler.
> > 
> > At the same time don't bother to dynamically allocate a struct class for
> > uio, just declare one statically.  Less code is needed and it is easier
> > to set the class parameters.tune the class
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

