Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2F0U6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:58:11 -0400
Received: from mga07.intel.com ([143.182.124.22]:24473 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757317Ab2F0U6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:58:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120627090521.GM31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda>
	<20120627090521.GM31212@elgon.mountain>
Date: Wed, 27 Jun 2012 13:58:06 -0700
Message-ID: <CABE8wwt-56EzC4Tmh8FyGPS+ftgNz3EAh7qfRxpc9CZizOqQqQ@mail.gmail.com>
Subject: Re: [patch -resend] [SCSI] isci: add a couple __iomem annotations
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ed Nadolski <edmund.nadolski@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 2:05 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> These are __iomem.  Sparse complains if we don't have that.
>
> drivers/scsi/isci/phy.c +149 70: warning:
>        incorrect type in initializer (different address spaces)
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Sent on Wed, 18 Jan 2012.
>

Thanks for nudge, this fell off the radar.  I'll get this into -next
with the rest of the pending bits.
