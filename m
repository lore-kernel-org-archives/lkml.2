Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2KPU7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:59:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2KPU7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:59:03 -0500
Date: Fri, 16 Nov 2012 23:58:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/serqt_usb2: Refactor qt_status_change_check() in
 serqt_usb2.c
Message-ID: <20121116205850.GM11566@mwanda>
References: <1353097162-4479-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353097162-4479-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 05:19:22AM +0900, YAMANE Toshiaki wrote:
> Modify qt_status_change_check() and delete qt_status_change().
> 

Thanks for doing that.  I think it's a lot easier to read that way.

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

