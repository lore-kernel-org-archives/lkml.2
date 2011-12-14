Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1LNQzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:55:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:54621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab1LNQzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:55:36 -0500
Message-ID: <1323875585.28489.48.camel@twins>
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20111214150359.GA840@kroah.com>
References: <20111214154844.3ad4e1d685c7987cba0820a0@canb.auug.org.au>
	 <1323854697.28489.7.camel@twins> <20111214150359.GA840@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 14 Dec 2011 16:13:05 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 07:03 -0800, Greg KH wrote:

> I'll remove the use of kfree in the WARN_ON(), which should solve this
> problem.

The alternative is that we introduce something like CONFIG_KREF_DEBUG
and out-of-line the functions in that case while also adding more debug
checks. Alexey recently proposed a refcnt.h thing that almost does what
kref does but has different debug checks.


