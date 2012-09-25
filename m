Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2IYNiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:38:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49208 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2IYNiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:38:12 -0400
Date: Tue, 25 Sep 2012 16:37:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, ldv-project@linuxtesting.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: sbe-2t3e3: fix error handling in
 t3e3_init_channel()
Message-ID: <20120925133745.GU4587@mwanda>
References: <1348577762-25503-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348577762-25503-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 04:56:02PM +0400, Alexey Khoroshilov wrote:
> t3e3_init_channel() incorrectly handles errors in several places:
> it returns zero and does not deallocate all required resources.
> The patch fixes that places.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Looks good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
