Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296Ab0J1S3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:29:25 -0400
Received: from mail.perches.com ([173.55.12.10]:3647 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab0J1S3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:29:21 -0400
Subject: Re: How do I add yaffs file system to mainline?
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Charles Manning <manningc2@actrix.gen.nz>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20101028180845.GA2573@kroah.com>
References: <201010290455.02390.manningc2@actrix.gen.nz>
	 <20101028102641.d936aec8.randy.dunlap@oracle.com>
	 <20101028174432.GA2001@kroah.com>
	 <201010290655.39490.manningc2@actrix.gen.nz>
	 <20101028180845.GA2573@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 11:29:18 -0700
Message-ID: <1288290559.1836.23.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 11:08 -0700, Greg KH wrote:
> On Fri, Oct 29, 2010 at 06:55:39AM +1300, Charles Manning wrote:
> > I know there is a style guide etc, but when we're talking about processing 15k 
> > loc then some of those rules might be slightly bendable.
> 
> Not really.
> 
> Have you run it through sparse and scripts/checkpatch.pl?  If not,
> please do so and resolve all of the issues that they bring up.

I wouldn't do that.  Checkpatch is useful but frequently wrong.
By all means do use checkpatch, but please use your own taste to
determine what you think needs fixing.


