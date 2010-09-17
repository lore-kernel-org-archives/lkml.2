Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0IQUuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:50:44 -0400
Received: from www.tglx.de ([62.245.132.106]:36033 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab0IQUun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:50:43 -0400
Date: Fri, 17 Sep 2010 22:50:37 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uio: Don't clear driver data
Message-ID: <20100917205037.GB2522@local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <m1occ0894p.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009172232530.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009172232530.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:33:57PM +0200, Thomas Gleixner wrote:
> 
> 
> On Tue, 14 Sep 2010, Eric W. Biederman wrote:
> 
> > 
> > Currently uio sets it's driver data to NULL just as it is unregistering
> > attributes.  sysfs maks the guaranatee that it will not call attributes
>   
>   s/maks/makes/
> 
> > after device_destroy is called so this is unncessary and leads to lots
> > of unnecessary code in uio.c
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

