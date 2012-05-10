Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549Ab2EJT2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 15:28:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44903 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760688Ab2EJT2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 15:28:41 -0400
Date: Thu, 10 May 2012 21:28:36 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com
Subject: Re: [PATCH] ramster: switch over to zsmalloc and crypto interface
Message-ID: <20120510192836.GA17750@jak-linux.org>
References: <1336676781-8571-1-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336676781-8571-1-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 12:06:21PM -0700, Dan Magenheimer wrote:
> RAMster does many zcache-like things.  In order to avoid major
> merge conflicts at 3.4, ramster used lzo1x directly for compression
> and retained a local copy of xvmalloc, while zcache moved to the
> new zsmalloc allocator and the crypto API.
> 
> This patch moves ramster forward to use zsmalloc and crypto.
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com

Nothing important, but the right ">" is missing here.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
