Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab1ADBvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 20:51:33 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47957 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751339Ab1ADBvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 20:51:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/lLbdB6ZjlneoIJF7sRyonn4NjOrPFbhuTs52oTi
	IfM6ThSS+YX6Ip
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20110103162918.577a9620@annuminas.surriel.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 02:51:20 +0100
Message-ID: <1294105880.5617.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 16:29 -0500, Rik van Riel wrote:
> From: Mike Galbraith <efault@gmx.de>
> 
> Add a yield_to function to the scheduler code, allowing us to
> give enough of our timeslice to another thread to allow it to
> run and release whatever resource we need it to release.
> 
> We may want to use this to provide a sys_yield_to system call
> one day.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> --- 
> Mike, want to change the above into a Signed-off-by: ? :)
> This code seems to work well.

Done.

	-Mike

