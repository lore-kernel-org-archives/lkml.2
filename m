Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1KIBC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:02:59 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47570 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1KIBCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:02:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135920824"
Date: Tue, 8 Nov 2011 17:02:02 -0800
From: David Brown <davidb@codeaurora.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Richard Kuo <rkuo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hexagon: Use resource_size function
Message-ID: <20111109010202.GA16505@huya.qualcomm.com>
References: <1320778170.8062.134.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320778170.8062.134.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor nits about the formatting of the patch.

On Tue, Nov 08, 2011 at 07:49:30PM +0100, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>

Shouldn't need a From: line, since it is the same as the email you
sent it from.

>  Use resource_size function on resource object
>  instead of explicit computation.

The commit text shouldn't be indented.

>  The semantic patch that makes this change is available
>  in scripts/coccinelle/api/resource_size.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/

I'm curious if these patches are generated directly by coccinelle,
since they don't appear to be coming from git.  It'd be nice to have
diffstats in them (especially when they are larger).

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
