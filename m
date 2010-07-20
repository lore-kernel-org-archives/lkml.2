Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513Ab0GTUWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:22:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40469 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab0GTUWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jhktLalTcB/hGN8WScKFdJV37n4VrE8JckVUQVB87SmpNqCyIOaxnnipFTri9s+TWD
         jlxk84prtqQM2MO+OFJVp9WsD6QpS1RJ6J9LuwULS31QqVmbfrLgekmCLVaKnNICafUw
         cpDlxnkJp9SJD/XZkh2TWplGWSgOBWGpR3mPg=
Date: Wed, 21 Jul 2010 00:21:56 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 6/8] xfs: fix unsigned underflow
Message-ID: <20100720202155.GA31829@albatros>
References: <1279219605-12631-1-git-send-email-segooon@gmail.com>
 <20100715212116.GA7013@infradead.org>
 <1279654533.1859.242.camel@doink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279654533.1859.242.camel@doink>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 14:35 -0500, Alex Elder wrote:
> On Thu, 2010-07-15 at 17:21 -0400, Christoph Hellwig wrote:
> > On Thu, Jul 15, 2010 at 10:46:45PM +0400, Kulikov Vasiliy wrote:
> > > map_len is unsigned. Checking map_len <= 0 is buggy when it should be
> > > below zero. So, check exact expression instead of map_len.
> > > 
> > > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> > 
> > Looks good,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> Looks good to me too.  Do you want me to pull this
> in via the XFS tree, or do you have other plans?
Yes, pull it please.

> 
> 					-Alex
> 
