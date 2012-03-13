Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2CMMF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:05:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59682 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab2CMMFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:05:23 -0400
Date: Tue, 13 Mar 2012 08:05:14 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
Message-ID: <20120313120514.GA17538@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120302025554.GA13493@joana>
 <20120301.221643.881299898523907213.davem@davemloft.net>
 <20120301.222316.1877216960521396397.davem@davemloft.net>
 <20120301.222604.1508242694024394849.davem@davemloft.net>
 <1330661602.1939.13.camel@joe2Laptop>
 <1330666534.1939.19.camel@joe2Laptop>
 <1330667673.1939.22.camel@joe2Laptop>
 <1331619783.7100.8.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331619783.7100.8.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:23:03PM -0700, Joe Perches wrote:
> Suggest the shorter pr_<level> instead of printk(KERN_<LEVEL>.
> 
> Prefer to use pr_<level> over bare printks.
> Prefer to use pr_warn over pr_warning.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Is this even worth a warning?   I don't think so....

   	     	     		  	- Ted
