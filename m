Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab1D1P5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:57:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32825 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759658Ab1D1P5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:57:51 -0400
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Colin Ian King <colin.king@ubuntu.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <1303928753.2417.6.camel@lenovo>
References: <1303920553.2583.7.camel@mulgrave.site>
	 <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site>
	 <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site>
	 <1303925374-sup-7968@think>  <1303926637.2583.17.camel@mulgrave.site>
	 <1303928753.2417.6.camel@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 10:57:42 -0500
Message-ID: <1304006262.2598.2.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 19:25 +0100, Colin Ian King wrote:
> Just like to add that I've seen almost identical issues with 2.6.38
> copying large amounts of data to an ext4 filesystem with systems with
> small amounts of memory.
> 
> I found that increasing /sys/fs/ext4/sdaX/max_writeback_mb_bump worked
> around the issue.

With the PREEMPT kernel, values of 256 and 512 don't prevent kswapd
spinning up to 99% and staying there.

James


