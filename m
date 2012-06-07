Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab2FGIjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:39:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26679 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab2FGIjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:39:43 -0400
Date: Thu, 7 Jun 2012 11:39:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: gregkh@linuxfoundation.org, siglesias@igalia.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] Staging: ipack/bridges/tpci200: remove gotos in
 tpci200_free_irq().
Message-ID: <20120607083901.GK4400@mwanda>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:24:50AM +0200, Miguel Gómez wrote:
> Handle error conditions with simple returns instead of usig gotos.
> 
> Signed-off-by: Miguel Gómez <magomez@igalia.com>

Nope.  It was still supposed to release the lock on success.

Keep the out_unlock label, and remove the out label.

regards,
dan carpenter

