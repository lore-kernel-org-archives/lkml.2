Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab1BOSUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:20:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:29397 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab1BOSUh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Feb 2011 13:20:37 -0500
Date: Tue, 15 Feb 2011 13:18:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@suse.de>
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
Message-ID: <20110215181837.GA26885@dumpdata.com>
References: <20110207032608.GA27453@ca-server1.us.oracle.com>
 <20110215165353.GA6118@dumpdata.com>
 <20110215172548.GD18437@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215172548.GD18437@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D5AC394.0078:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 09:25:48AM -0800, Greg KH wrote:
> On Tue, Feb 15, 2011 at 11:53:53AM -0500, Konrad Rzeszutek Wilk wrote:
> > On Sun, Feb 06, 2011 at 07:26:08PM -0800, Dan Magenheimer wrote:
> > > [PATCH V2 2/3] drivers/staging: zcache: host services and PAM services
> > 
> > Hey Dan,
> > 
> > I did a simple review of just reading the code and trying to grok it.
> > 
> > Greg,
> > 
> > How does the review work in staging tree? Would you just take
> > new patches from Dan based on my review and he should stick
> > 'Reviewed-by: Konrad...' or .. ?
> 
> I would, if I hadn't already committed these patches, so it'e a bit too
> late for adding that, sorry.

That is OK. Thanks.
