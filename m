Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab2J2Pnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:43:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53762 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2J2Pnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:43:33 -0400
Message-ID: <508EA417.1040304@linux.vnet.ibm.com>
Date: Mon, 29 Oct 2012 10:43:19 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, gaowanlong@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] zram/zsmalloc promotion
References: <1351501009-15111-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1351501009-15111-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102915-2398-0000-0000-00000CFFB4A5
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00186698; UDB=6.00042292; UTC=2012-10-29
 15:43:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 03:56 AM, Minchan Kim wrote:
> This patchset promotes zram/zsmalloc from staging.
> Both are very clean and zram have been used by many embedded product
> for a long time.
> It's time to go out of staging.

Agreed!

> Greg, Jens is already OK that zram is located under driver/blocks/.
> The issue remained is where we put zsmalloc.

Doesn't matter much for me, but seems to be leaning toward /lib,
baring an opinion from Andrew that it go in /mm.  /lib is fine by me.

Seth

