Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2G3MeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:34:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38311 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2G3MeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:34:18 -0400
Message-ID: <50167F3D.801@linux.vnet.ibm.com>
Date: Mon, 30 Jul 2012 07:34:05 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] [SCSI] ipr: remove an unneeded check
References: <20120730081822.GF15702@elgon.mountain>
In-Reply-To: <20120730081822.GF15702@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073012-7408-0000-0000-000007342B57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 03:18 AM, Dan Carpenter wrote:
> "rc" is always zero here, so there is no need to check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks!

Acked-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center




