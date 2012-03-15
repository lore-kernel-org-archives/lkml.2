Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2COCma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:42:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48514 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754038Ab2COCm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:42:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+RNlpume+RxuQF+pTJQtjCG5hgqUKBVy3vzP8CJV
	5h0xJJ6ttIm9L2
Message-ID: <1331779343.14263.6.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Date: Thu, 15 Mar 2012 03:42:23 +0100
In-Reply-To: <20120314165657.GA19117@linux.vnet.ibm.com>
References: <20120314002414.GA21561@linux.vnet.ibm.com>
	 <1331717099.5752.15.camel@marge.simpson.net>
	 <1331728841.7465.7.camel@marge.simpson.net>
	 <20120314130801.GA11722@sgi.com> <20120314151717.GA2435@linux.vnet.ibm.com>
	 <20120314165657.GA19117@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 09:56 -0700, Paul E. McKenney wrote:

> Does the following work better?  It does pass my fake-big-system tests
> (more testing in the works).

Yup, tip booted fine.  Thanks!  I'll test, see if it gets upset.

-Mike

