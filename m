Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab1BOR1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:27:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:50352 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab1BOR13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:27:29 -0500
Date: Tue, 15 Feb 2011 09:25:48 -0800
From: Greg KH <gregkh@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, chris.mason@oracle.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org, kurt.hackel@oracle.com,
        npiggin@kernel.dk, riel@redhat.com, mel@csn.ul.ie,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        sfr@canb.auug.org.au, wfg@mail.ustc.edu.cn, tytso@mit.edu,
        viro@ZenIV.linux.org.uk, hughd@google.com, hannes@cmpxchg.org
Subject: Re: [PATCH V2 2/3] drivers/staging: zcache: host services and PAM
 services
Message-ID: <20110215172548.GD18437@suse.de>
References: <20110207032608.GA27453@ca-server1.us.oracle.com>
 <20110215165353.GA6118@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215165353.GA6118@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 11:53:53AM -0500, Konrad Rzeszutek Wilk wrote:
> On Sun, Feb 06, 2011 at 07:26:08PM -0800, Dan Magenheimer wrote:
> > [PATCH V2 2/3] drivers/staging: zcache: host services and PAM services
> 
> Hey Dan,
> 
> I did a simple review of just reading the code and trying to grok it.
> 
> Greg,
> 
> How does the review work in staging tree? Would you just take
> new patches from Dan based on my review and he should stick
> 'Reviewed-by: Konrad...' or .. ?

I would, if I hadn't already committed these patches, so it'e a bit too
late for adding that, sorry.

thanks,

greg k-h
