Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab2F2Gor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:44:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17826 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2F2Gop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:44:45 -0400
Date: Fri, 29 Jun 2012 09:44:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] sgi-xp: nested calls to spin_lock_irqsave()
Message-ID: <20120629064432.GM3007@mwanda>
References: <20120627135155.GA3464@sgi.com>
 <20120628150342.aaa4ad2d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628150342.aaa4ad2d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is actually my patch, so the patch description is my fault.
It's a static checker patch and I don't have the hardware, but the
changelog could have been written more clearly as well.

Robin, the trick to resending patches is to put a:

From:  Dan Carpenter <dan.carpenter@oracle.com>

before the patch description and then it shows up as mine.

Also, btw, Robin, I'm looking through my mailbox again and you did
respond to the patch the first time I sent it.  Sorry, that I didn't
see that before, and thanks for your help on this.

regards,
dan carpenter

