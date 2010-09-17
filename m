Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0IQUt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:49:26 -0400
Received: from www.tglx.de ([62.245.132.106]:36013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab0IQUtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:49:25 -0400
Date: Fri, 17 Sep 2010 22:49:20 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] uio: Fix lack of locking in init_uio_class
Message-ID: <20100917204919.GA2522@local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <m1sk1c895g.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009172231580.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009172231580.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:32:35PM +0200, Thomas Gleixner wrote:
> 
> 
> On Tue, 14 Sep 2010, Eric W. Biederman wrote:
> 
> > 
> > There is no locking in init_uio_class so multiple
> > drivers can race and create multiple uio classes.
> > 
> > Fix this by simplifying the code.   In particular always
> > register the uio class during module_init and make things
> > simpler.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
