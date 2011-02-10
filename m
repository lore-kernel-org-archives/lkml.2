Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1BJLXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 06:23:47 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38231 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1BJLXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 06:23:46 -0500
Message-ID: <4D53CAE8.1060007@vflare.org>
Date: Thu, 10 Feb 2011 16:54:24 +0530
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: linux-next: manual merge of the staging tree with the staging.current
 tree
References: <20110210163527.3b2cc580.sfr@canb.auug.org.au>
In-Reply-To: <20110210163527.3b2cc580.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2011 11:05 AM, Stephen Rothwell wrote:
>
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/zram/zram_drv.c between commit
> 5414e557fca545614ceedc3d3496f747457e2e3b ("staging: zram: fix data
> corruption issue") from the staging.current tree and commit
> 2787f959d6c5fb258d964218ac75346019f49ee9 ("zram: Return zero'd pages on
> new reads") from the staging tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary.

The fix looks correct to me. Thanks for fixing this.

Nitin
