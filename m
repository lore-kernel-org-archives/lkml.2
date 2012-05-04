Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab2EDPY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:24:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48148 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2EDPYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:24:24 -0400
Date: Fri, 4 May 2012 08:04:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120504150411.GC2411@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04>
 <20120428034257.GA2495@linux.vnet.ibm.com>
 <20120501000245.GA4329@linux.vnet.ibm.com>
 <4F9FA50C.9070600@wanadoo.fr>
 <20120501154513.GD2441@linux.vnet.ibm.com>
 <4FA3EAEE.9030601@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FA3EAEE.9030601@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050415-5518-0000-0000-0000042665EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 04:42:54PM +0200, Pascal Chapperon wrote:
> Le 01/05/2012 17:45, Paul E. McKenney a écrit :
> 
> >Here is my RCU_FAST_NO_HZ patch stack on top of v3.4-rc4.
> >
> >Or you can pull branch fnh.2012.05.01a from:
> >
> >	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> >
> >							Thanx, Paul
> >
> I applied your global patch on top of v3.4-rc4. But the slowdown is
> worse than before : boot sequence took 80s instead 20-30s (12s for
> initramfs instead of 2s).
> 
> I'll send you rcu tracing log in a second mail.

Hmmm...  Well, I guess I am glad that I finally did something that
had an effect, but I sure wish that the effect had been in the other
direction!

Just to make sure I understand: the difference between the 20-30s and
the 80s is exactly the patch I sent you?

							Thanx, Paul

