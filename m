Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057Ab2JYGdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:33:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44294 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab2JYGdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:33:36 -0400
Date: Thu, 25 Oct 2012 09:33:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ed Cashin <ecashin@coraid.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: avoid using skb member after dev_queue_xmit
Message-ID: <20121025063322.GH20754@mwanda>
References: <d1523cdc8a606d65418dc242e958ff1c@coraid.com>
 <20121024150807.82ce2677.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024150807.82ce2677.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 03:08:07PM -0700, Andrew Morton wrote:
> On Wed, 24 Oct 2012 14:26:13 -0400
> Ed Cashin <ecashin@coraid.com> wrote:
> 
> > After calling dev_queue_xmit it is no longer safe to access the
> > members of the skb.
> > 
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> hm, that was clever.  How did Dan detect this bug?

It was a Smatch thing, but it wasn't enabled by default.  I think I
will enable it.  This is the second bug use after dev_queue_xmit()
in two years.

regards,
dan carpenter

