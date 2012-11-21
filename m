Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2KUOOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:14:54 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34195 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2KUOOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:14:53 -0500
Message-ID: <50ACE1D4.3050104@gmail.com>
Date: Wed, 21 Nov 2012 15:14:44 +0100
From: MAACHE Mehdi <mehdi.maache@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.10) Gecko/20121029 Thunderbird/10.0.10
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tdent48227@gmail.com
Subject: Re: [PATCH] Staging: rtl8187se: bugfix in r8180_wx.c
References: <1353504042-9422-1-git-send-email-mehdi.maache@gmail.com> <20121121134200.GH6186@mwanda>
In-Reply-To: <20121121134200.GH6186@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 21/11/2012 14:42, Dan Carpenter a écrit :

> 
> Here is a better changelog.  Please resend with this or something
> similar.
> 
> ---
> Subject: [PATCH v2] Staging: rtl8187se: remove check for IW_ENCODE_DISABLED
> 
> The original code had a no-op stub where it checked if
> IW_ENCODE_DISABLED and did nothing.  Then in a cleanup patch we
> accidentally turned the check on.  That was: de171bd6ff "Staging:
> rtl8187se: r8180_wx: fixed a lot of checkpatch.pl issues".
> 
> The check should just be removed.
> ---
> 
> regards,
> dan carpenter
> 


Thanks again. I wiil do this and next time, I will try a better description.

regards,

maache mehdi
