Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2KUNmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:42:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22576 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2KUNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:42:20 -0500
Date: Wed, 21 Nov 2012 16:42:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: MAACHE Mehdi <mehdi.maache@gmail.com>
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tdent48227@gmail.com
Subject: Re: [PATCH] Staging: rtl8187se: bugfix in r8180_wx.c
Message-ID: <20121121134200.GH6186@mwanda>
References: <1353504042-9422-1-git-send-email-mehdi.maache@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353504042-9422-1-git-send-email-mehdi.maache@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 02:20:42PM +0100, MAACHE Mehdi wrote:
> This bug was introduced in de171bd6ff "Staging: rtl8187se: r8180_wx: fixed a lot of checkpatch.pl issues".
> 

The change log should describe the patch so we don't have to read
the code to know what it does.  Idealy it would describe the user
visible effects of the code, but neither you nor I really know what
those are.

Here is a better changelog.  Please resend with this or something
similar.

---
Subject: [PATCH v2] Staging: rtl8187se: remove check for IW_ENCODE_DISABLED

The original code had a no-op stub where it checked if
IW_ENCODE_DISABLED and did nothing.  Then in a cleanup patch we
accidentally turned the check on.  That was: de171bd6ff "Staging:
rtl8187se: r8180_wx: fixed a lot of checkpatch.pl issues".

The check should just be removed.
---

regards,
dan carpenter

