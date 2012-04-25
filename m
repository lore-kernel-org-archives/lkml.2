Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2DYSOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:14:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2DYSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:14:32 -0400
Date: Wed, 25 Apr 2012 11:14:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/6] zsmalloc: clean up and fix arch dependency
Message-ID: <20120425181428.GA23016@kroah.com>
References: <1335334994-22138-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335334994-22138-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 03:23:08PM +0900, Minchan Kim wrote:
> This patchset has some clean up patches(1-5) and remove 
> set_bit, flush_tlb for portability in [6/6].
> 
> Minchan Kim (6):
>   zsmalloc: use PageFlag macro instead of [set|test]_bit

I've only applied this one patch, so feel free to drop it from your
series when you redo the others for your next round.

thanks,

greg k-h
