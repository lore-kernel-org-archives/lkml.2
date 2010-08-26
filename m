Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0HZHvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:51:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40844 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752352Ab0HZHvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:51:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/AUCN1h47AoGYbKXl6r6hRX6QYfHdmCgqzHVd+rH
	fjijG1CDbECiP/
Subject: Re: 2.6.32 cgroup regression
From: Mike Galbraith <efault@gmx.de>
To: Josh Hunt <johunt@akamai.com>
Cc: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4C757AB4.10708@akamai.com>
References: <4C74274D.9060300@akamai.com>
	 <1282715761.20033.23.camel@marge.simson.net>  <4C757AB4.10708@akamai.com>
Content-Type: text/plain
Date: Thu, 26 Aug 2010 09:51:51 +0200
Message-Id: <1282809111.10326.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 13:19 -0700, Josh Hunt wrote:
> On 08/24/2010 10:56 PM, Mike Galbraith wrote:
> > 
> > Excellent timing you have.  I have a tree of backports, but I wasn't
> > counting this commit as a must have, merely highly desirable.  This
> > testcase showed that it's a needed fix.
> >   
> 
> I'd be interested in looking at this tree when it's available.

(sent quilt stack offline, anybody else wants it, holler, and you'll
receive one [absolutely free!] 50k tarball)

