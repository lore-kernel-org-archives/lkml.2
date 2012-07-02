Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab2GBMqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:46:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23342 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBMqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:46:01 -0400
Date: Mon, 2 Jul 2012 15:45:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: automated warning notifications
Message-ID: <20120702124551.GD4519@mwanda>
References: <20120614172523.GB4400@mwanda>
 <20120615014835.GA5695@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615014835.GA5695@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 09:48:35AM +0800, Fengguang Wu wrote:
> Hi Dan,
> 
> On Thu, Jun 14, 2012 at 08:25:23PM +0300, Dan Carpenter wrote:
> > Hi Fengguang,
> > 
> > I also check new static checker warnings and sometimes email people.
> 
> That would be nice!
> 
> > I wonder if we are duplicating each others work.  For example, did
> > you send an email asking about the following Sparse warning:
> > 
> > sound/soc/codecs/ab8500-codec.c:1959:53: warning: cast truncates bits from constant value (1013 becomes 13)
> 
> I did try sending out sparse warnings to people, some time ago...

Apparently you have started up again?  We're starting to trod on
each other's toes and people are getting annoyed with me because I
am reporting them after you...  :/

Randy has suggested that we send these automated messages to
kernel-janitors.  I don't know how the other people on kernel
janitors feel about this but I would be fine with it.

regards,
dan carpenter

