Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2KSHJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:09:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20518 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2KSHJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:09:22 -0500
Date: Mon, 19 Nov 2012 10:08:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: pe1dnn@amsat.org, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: wlags49_h2: ap_h2: fixes coding style issues
Message-ID: <20121119070859.GC6135@mwanda>
References: <1353084759-8792-1-git-send-email-johanmeiring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353084759-8792-1-git-send-email-johanmeiring@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:52:39PM +0200, Johan Meiring wrote:
>  		COMP_ID_FW_AP,
> -		2,							/* Variant /
                                                                                  ^^
You fixed a bug here. :) Always mention bugs fixed in the changelog.

> -		2,							/* Major */

regards,
dan carpenter

