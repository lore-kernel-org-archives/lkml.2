Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250Ab2CNRHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:07:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59180 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755831Ab2CNRHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:07:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18xqMxElrUxDPqWcydKB/N/4ke/RCjfYAV7W+YjkT
	AzJf/6Prz08Qqk
Message-ID: <1331744826.31111.27.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Date: Wed, 14 Mar 2012 18:07:06 +0100
In-Reply-To: <20120314151717.GA2435@linux.vnet.ibm.com>
References: <20120314002414.GA21561@linux.vnet.ibm.com>
	 <1331717099.5752.15.camel@marge.simpson.net>
	 <1331728841.7465.7.camel@marge.simpson.net>
	 <20120314130801.GA11722@sgi.com> <20120314151717.GA2435@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 08:17 -0700, Paul E. McKenney wrote:

> And thank you both for the testing!!!

Try to beat RCU into submission with rocks and sticks, or test patch
from RCU expert... not a hard choice.  I will most happily test ;-)

-Mike 

