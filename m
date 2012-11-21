Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2KUQTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:19:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29463 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab2KUQTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:19:24 -0500
Date: Wed, 21 Nov 2012 19:19:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: devel@driverdev.osuosl.org, sachin.kamat@linaro.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [V2 PATCH 1/3] staging: ozwpan: Remove redundant null check
 before kfree in ozpd.c
Message-ID: <20121121161859.GI6186@mwanda>
References: <20121120163513.GC4990@kroah.com>
 <1353501977-6585-2-git-send-email-rgujare@ozmodevices.com>
 <20121121130527.GH11248@mwanda>
 <50ACDA54.7040508@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ACDA54.7040508@ozmodevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When someone sends a patch there are a several possible responses:
1) Ack the patch.
2) Request that the submitter redo it.  The downside is that no one
   likes redoing patches.
3) Reject the patch.
4) Redo it yourself and say "Based on a patch from Sachin Kamat".
   This isn't nice because everyone wants author credit.
5) Redo it and get permission from the original author to give them
   author credit get their signed-off-by.

Your version is better, that's not even a question.  It's just that
now we're in an awkward place and having long discussions about
trivial patches that are going to be re-written anyway.  :P

regards,
dan carpenter
