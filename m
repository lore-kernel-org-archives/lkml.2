Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2LKGck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 01:32:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39481 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2LKGcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 01:32:39 -0500
Date: Tue, 11 Dec 2012 09:32:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        marcos.souza.org@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8712: avoid a useless call to memset().
Message-ID: <20121211063215.GU22569@mwanda>
References: <0121210085516.GO6568@mwanda>
 <1355185248-26842-1-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355185248-26842-1-git-send-email-tipecaml@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 01:20:48AM +0100, Cyril Roelandt wrote:
> In r8711_wx_get_wap(), make sure we do not call memcpy() on a memory area that
> has just been zeroed by a call to memset().
> 

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

