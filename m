Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2EaAqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:46:50 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40112 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2EaAqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:46:49 -0400
Date: Wed, 30 May 2012 20:46:44 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2 v2] zram: clean up handle
Message-ID: <20120531004643.GB401@localhost.localdomain>
References: <1337737402-16543-1-git-send-email-minchan@kernel.org>
 <1337737402-16543-2-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337737402-16543-2-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:43:22AM +0900, Minchan Kim wrote:
> zram's handle variable can store handle of zsmalloc in case of
> compressing efficiently. Otherwise, it stores point of page descriptor.
> This patch clean up the mess by union struct.
> 
> changelog
>   * from v1
> 	- none(new add in v2)
> 
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks for doing this!
> Signed-off-by: Minchan Kim <minchan@kernel.org>
