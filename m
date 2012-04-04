Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab2DDVgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:36:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40815 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab2DDVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:36:40 -0400
Date: Wed, 4 Apr 2012 14:36:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120404213633.GI2302@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120404152726.GB16299@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404152726.GB16299@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040421-3352-0000-0000-000003D15D23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 11:27:27AM -0400, Josh Boyer wrote:
> Hi Paul,
> 
> We've had a few reports of some boot slowdowns with the 3.3 rebase we
> did in Fedora 16.  One of our users volunteered to bisect a vanilla
> kernel and wound up at "rcu: Permit dyntick-idle with callbacks pending
> (commit 7cb924990)".  You can find more details in the bug [1], but it's
> been reported on both physical hardware and in virtual machines.
> 
> Have you seen anything like this in your testing?  Given the user used a
> vanilla 3.3 kernel, I'm wondering if there is a targetted fix that might
> be backported.  If so, it would be good to get that headed to the 3.3.y
> stable tree.
> 
> josh
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=806548

I will look into this.  In the meantime, does setting
CONFIG_RCU_FAST_NO_HZ=n get rid of the slowdowns?

							Thanx, Paul

