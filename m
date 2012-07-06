Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2GFIWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:22:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37175 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2GFIWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:22:12 -0400
Date: Fri, 6 Jul 2012 11:21:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, arnaud.patard@rtp-net.org,
        aaro.koskinen@iki.fi
Subject: Re: [PATCH 17/19] Staging: xgifb: Rework some conditions in
 XGI_SetCRT2ModeRegs().
Message-ID: <20120706082116.GH4462@mwanda>
References: <20120706065618.GA29479@mwanda>
 <4FF69EE4.3080707@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FF69EE4.3080707@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:16:36AM +0200, Miguel Gómez wrote:
> >On Thu, Jul 05, 2012 at 04:46:00PM +0200, Miguel Gómez wrote:
> >>Rework some conditions to reduce indentation and fix style warnings.
> >>
> >
> >Instead of a do { } while(0); it would be better to just use gotos.
> 
> Point taken. I used the do-while because I didn't want to abuse
> gotos, but if there's no problem with them I'll change the patch.
> 

That style of goto is fine/standard in the kernel.

regards,
dan carpenter
