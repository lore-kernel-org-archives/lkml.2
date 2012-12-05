Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2LEHMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 02:12:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25181 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2LEHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 02:12:23 -0500
Date: Wed, 5 Dec 2012 10:11:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        kernel-janitors@vger.kernel.org, yongjun_wei@trendmicro.com.cn,
        marcos.souza.org@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8712: avoid a useless call to memset().
Message-ID: <20121205071156.GL6568@mwanda>
References: <1354670522-27144-1-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354670522-27144-1-git-send-email-tipecaml@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 02:22:02AM +0100, Cyril Roelandt wrote:
> In r8711_wx_get_wap(), make sure we do not call memcpy() on a memory area that
> has just been zeroed by a call to memset().
> 

I look at it like the original code is fine.  Your version is also
fine but is it worth the churn?  Also the curly braces are not
needed.

regards,
dan carpenter

