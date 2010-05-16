Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0EPM7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 08:59:12 -0400
Received: from ns1.co-raid.com ([12.51.113.4]:34893 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754479Ab0EPM7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 08:59:07 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 May 2010 08:59:07 EDT
Subject: Re: [PATCH 35/37] drivers/block/aoe: Use kmemdup
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <Pine.LNX.4.64.1005152323310.21345@ask.diku.dk>
Date: Sun, 16 May 2010 08:42:59 -0400
Cc: kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>
Content-Transfer-Encoding: 7bit
Message-Id: <FA04A0D0-4BAF-4E1D-B8E8-3148E290009F@coraid.com>
References: <Pine.LNX.4.64.1005152323310.21345@ask.diku.dk>
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 15, 2010, at 5:23 PM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.

I have seen this patch but have no comment about it specifically.

(Because the argument about whether this kind of change
adds value in general has already taken place.  I'd say no, but that's 
based on a maybe faulty idea that if folks weren't doing this they'd have
more time for reviewing patches, etc.)

-- 
  Ed Cashin
  ecashin@coraid.com

