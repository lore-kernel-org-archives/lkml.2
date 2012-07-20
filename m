Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2GTGng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:43:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39383 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2GTGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:43:34 -0400
Date: Fri, 20 Jul 2012 09:43:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: pstore/ram: Add ftrace messages handling
Message-ID: <20120720064320.GJ16348@mwanda>
References: <20120719142856.GA25184@elgon.mountain>
 <20120719232030.GA2573@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719232030.GA2573@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 04:20:32PM -0700, Anton Vorontsov wrote:
> Hi Dan,
> 
> On Thu, Jul 19, 2012 at 05:28:56PM +0300, Dan Carpenter wrote:
> > The patch a694d1b5916a: "pstore/ram: Add ftrace messages handling" 
> > from Jul 9, 2012, leads to the following Smatch complaint:
> 
> A nice tool. The homepage of Smatch doesn't explicitly say that, so
> I have to ask: is it a complete superset of sparse (i.e. does it
> produce all the warnings that the pure sparse can produce)?
> If so, I'll probably switch to it from the vanilla sparse.
> 

No.  It just uses Sparse as a parser.

regards,
dan carpenter

