Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2L0Oec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:34:32 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:57411 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2L0Oea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:34:30 -0500
Date: Thu, 27 Dec 2012 15:34:24 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] f2fs: add missing pretech.h include
Message-ID: <20121227143424.GB3223@osiris>
References: <20121227143032.GA3223@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121227143032.GA3223@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12122714-1948-0000-0000-000003E3CC28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 03:30:32PM +0100, Heiko Carstens wrote:
> From aa027f06dfb5b2fd27d6f92391d8340df671e82b Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Thu, 27 Dec 2012 15:22:27 +0100
> Subject: [PATCH] f2fs: add missing pretech.h include

That should have been "prefetch.h", obviously...
At least the patch is correct.

