Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2F2JcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:32:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48726 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2F2JcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:32:22 -0400
Date: Fri, 29 Jun 2012 12:32:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Zoltan Kelemen <zoltan.kelemen@digisec.se>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, willy@meta-x.org
Subject: Re: [PATCH 1/3] staging:panel: Rewrite for fixing synchronization
 issues
Message-ID: <20120629093200.GO5333@mwanda>
References: <4FECC539.8040303@digisec.se>
 <20120629072441.GN5333@mwanda>
 <20120629090516.8845AD52AA77@bmail04.one.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629090516.8845AD52AA77@bmail04.one.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 11:05:16AM +0200, Zoltan Kelemen wrote:
> On 29 jun 2012 09:24 "Dan Carpenter" <dan.carpenter@oracle.com> wrote:
> 
> > Gar...  Don't do this.  :/  Each bullet point here should be a
> > separate patch.  Please break it apart and resend.
> 
> I understand a large patch is harder to audit than small incremental changes, but the patch was the result of a code rewrite, where I attempted to summarize the changes in large in the bulleted list. There isn't a one-to-one correspondence between a bullet and a change in the code. Breaking the rewrite into small pieces would not only be quite hard but to some extent even more confusing to audit since you risk to see the leaves instead of the tree.
> 

We've done this before.  We can help you break it apart.

Step 1: Change all the existing spinlocks to spin_lock_bh().
Step 2: Do all the white space changes.
Step 3: Shuffle the global variable declarations around.

That's half the patch gone already.

regards,
dan carpenter

