Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2GaQTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:19:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52687 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab2GaQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:19:21 -0400
Date: Tue, 31 Jul 2012 09:19:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, devel@driverdev.osuosl.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 0/4] promote zcache from staging
Message-ID: <20120731161916.GA4941@kroah.com>
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <b95aec06-5a10-4f83-bdfd-e7f6adabd9df@default>
 <20120727205932.GA12650@localhost.localdomain>
 <d4656ba5-d6d1-4c36-a6c8-f6ecd193b31d@default>
 <5016DE4E.5050300@linux.vnet.ibm.com>
 <f47a6d86-785f-498c-8ee5-0d2df1b2616c@default>
 <20120731155843.GP4789@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731155843.GP4789@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 11:58:43AM -0400, Konrad Rzeszutek Wilk wrote:
> So in my head I feel that it is Ok to:
> 1) address the concerns that zcache has before it is unstaged
> 2) rip out the two-engine system with a one-engine system
>    (and see how well it behaves)
> 3) sysfs->debugfs as needed
> 4) other things as needed
> 
> I think we are getting hung-up what Greg said about adding features
> and the two-engine->one engine could be understood as that.
> While I think that is part of a staging effort to clean up the
> existing issues. Lets see what Greg thinks.

Greg has no idea, except I want to see the needed fixups happen before
new features get added.  Add the new features _after_ it is out of
staging.

greg k-h
