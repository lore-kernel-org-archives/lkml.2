Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab1CCQl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:41:29 -0500
Received: from xenotime.net ([184.105.210.51]:43783 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751471Ab1CCQl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:41:28 -0500
Date: Thu, 3 Mar 2011 08:41:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Jinqiu <crindy646@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix bug #13853: dereference pointer 'dev' before null
 check
Message-Id: <20110303084125.57f43b81.rdunlap@xenotime.net>
In-Reply-To: <20110303081156.GA14163@pengutronix.de>
References: <4D6EFAE5.4000400@gmail.com>
	<4D6F01DA.3040307@cn.fujitsu.com>
	<20110303081156.GA14163@pengutronix.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 09:11:56 +0100 Wolfram Sang wrote:

> Hi,
> 
> > Don't ever mention "bug #13853", because this number makes no sense
> > for everyone except you. A proper subject may be:
> > 
> > [PATCH] ariadne: fix possible null dereference.
> 
> I agree for the subject line. Still, in the body or maybe after the "---" I'd
> think it makes sense, so it is known there is a bugzilla entry to close? Also,
> using search engines, one will be able to dig up the patch.

It should just refer to the full bugzilla #13853 URL:
https://bugzilla.kernel.org/show_bug.cgi?id=13853

> > And please send your patches to proper maintainers and mailing list,
> > David Miller and netdev@vger.kernel.org in particular.
> 
> Yup. Using scripts/get_maintainers.pl is the way to go here.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
