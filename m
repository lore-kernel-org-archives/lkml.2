Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2G3MfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:35:01 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43507 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2G3MfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:35:00 -0400
Message-ID: <50167F1D.5030406@linux.vnet.ibm.com>
Date: Mon, 30 Jul 2012 07:33:33 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/2] [SCSI] ipr: missing unlock before a return
References: <20120730081635.GE15702@elgon.mountain>
In-Reply-To: <20120730081635.GE15702@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073012-5518-0000-0000-000006734C6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 03:16 AM, Dan Carpenter wrote:
> We recently changed the locking in this function, but this return was
> missed.  It needs an unlock and the IRQs need to be restored.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Thanks for catching this.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center




