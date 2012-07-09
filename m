Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2GIXVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:21:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43686 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751560Ab2GIXVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:21:08 -0400
Message-ID: <1341876067.6118.67.camel@joe2Laptop>
Subject: Re: +
 checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch added to
 -mm tree
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Date: Mon, 09 Jul 2012 16:21:07 -0700
In-Reply-To: <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
	 <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com>
	 <1341873376.6118.56.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 15:55 -0700, David Rientjes wrote:
> So, nack, don't start enforcing your own coding style and preferences in 
> checkpatch.pl.

Not just my opinion.

https://lkml.org/lkml/2008/12/23/138
--------------------------------------------------------
Date: Tue, 23 Dec 2008 10:08:50 -0800 (PST)
From: Linus Torvalds <>
[]
Another example of this is "sizeof". The kernel universally (I hope) has 
parenthesis around the sizeof argument, even though it's clearly not 
required by the C language. 

It's a coding standard. 
--------------------------------------------------------

cheers, Joe

