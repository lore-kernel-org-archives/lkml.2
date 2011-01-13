Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1AMNiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:38:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43547 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755886Ab1AMNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:38:08 -0500
Date: Thu, 13 Jan 2011 13:35:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nick Piggin <npiggin@kernel.dk>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: NFS root lockups with -next 20110113
Message-ID: <20110113133552.GD30351@opensource.wolfsonmicro.com>
References: <20110113120626.GB30351@opensource.wolfsonmicro.com>
 <8138.1294924927@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8138.1294924927@jrobl>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 10:22:07PM +0900, J. R. Okajima wrote:

> This and a report from Santosh Shilimkar look like the same problem
> which I reported, and I am testing this patch. If you can, please try it
> too.
> Note: Of course this is not offcial fix.

Seems to do the trick:

Tested-by: Mark Brown <broonie@opensource.wolsfonmicro.com>
