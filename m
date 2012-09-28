Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2I1G5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:57:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36964 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2I1G5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:57:21 -0400
Date: Fri, 28 Sep 2012 09:56:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: trivial@vger.kernel.org, perex@perex.cz, tiwai@suse.de,
        rusty@rustcorp.com.au, paul.gortmaker@windriver.com,
        eblennerhassett@audioscience.com, superquad.vortex2@gmail.com,
        den@openvz.org, kozerkov@parallels.com, axel.lin@gmail.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] sound: Remove unnecessary semicolon
Message-ID: <20120928065647.GM4587@mwanda>
References: <1348746198-26375-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348746198-26375-1-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:43:18PM +0200, Peter Senna Tschudin wrote:
> Remove unnecessary semicolon
> 
> And:
> sound/drivers/vx/vx_pcm.c: Convert spaces into tab
> 
> Found by http://coccinelle.lip6.fr/
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---

Next time, could you put a little comment here under the --- line
about what changed between v1 and v2?

regards,
dan carpenter

