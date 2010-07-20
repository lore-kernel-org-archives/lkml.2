Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0GTTfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:35:36 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42378 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab0GTTff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:35:35 -0400
Subject: Re: [PATCH 6/8] xfs: fix unsigned underflow
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <20100715212116.GA7013@infradead.org>
References: <1279219605-12631-1-git-send-email-segooon@gmail.com>
	 <20100715212116.GA7013@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 14:35:33 -0500
Message-ID: <1279654533.1859.242.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jul 2010 19:35:34.0411 (UTC) FILETIME=[B8D4FDB0:01CB2842]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 17:21 -0400, Christoph Hellwig wrote:
> On Thu, Jul 15, 2010 at 10:46:45PM +0400, Kulikov Vasiliy wrote:
> > map_len is unsigned. Checking map_len <= 0 is buggy when it should be
> > below zero. So, check exact expression instead of map_len.
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Looks good to me too.  Do you want me to pull this
in via the XFS tree, or do you have other plans?

					-Alex

