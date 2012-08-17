Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030835Ab2HQHrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:47:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43420 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2HQHrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:47:04 -0400
Date: Fri, 17 Aug 2012 10:46:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging/vme: fix checkpatch warning
Message-ID: <20120817074644.GL4559@mwanda>
References: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
 <1345179920-8303-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345179920-8303-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You've got the same subject repeated 5 times.

It would be better to merge all the vme_user.c printk fixes into
one patch.
[patch 1/3] Staging: vme: Fix a white space issue
[patch 2/3] Staging: vme: Use pr_ printks in vme_user.c
[patch 3/3] Staging: vme: Use pr_ printks in vme_pio2_core.c

It's not a huge deal, it just seems like there was some confusion on
how to break patches up.

regards,
dan carpenter

