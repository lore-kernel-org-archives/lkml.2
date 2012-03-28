Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2C1Mtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:49:35 -0400
Received: from verein.lst.de ([213.95.11.211]:51693 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2C1Mtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:49:33 -0400
Date: Wed, 28 Mar 2012 14:49:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3: update documentation with barrier=1 default
Message-ID: <20120328124932.GA16026@lst.de>
References: <1332923552-9854-1-git-send-email-stefanha@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332923552-9854-1-git-send-email-stefanha@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 09:32:32AM +0100, Stefan Hajnoczi wrote:
> Commit 00eacd6 ("ext3: make ext3 mount default to barrier=1") changed
> the default barrier mount option for ext3.  The documentation needs to
> be updated, so this patch does that.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

