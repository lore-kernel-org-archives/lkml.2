Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab2GFG5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:57:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19702 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2GFG5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:57:10 -0400
Date: Fri, 6 Jul 2012 09:56:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] Staging: xgifb: Rework some conditions in
 XGI_SetCRT2ModeRegs().
Message-ID: <20120706065618.GA29479@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 04:46:00PM +0200, Miguel Gómez wrote:
> Rework some conditions to reduce indentation and fix style warnings.
> 

Instead of a do { } while(0); it would be better to just use gotos.

regards,
dan carpenter

