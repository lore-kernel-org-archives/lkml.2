Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab2I1Lvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:51:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36515 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab2I1Lvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:51:44 -0400
Date: Fri, 28 Sep 2012 14:51:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bug report] [SCSI] mvumi: GFP_KERNEL under spin lock
Message-ID: <20120928115133.GX13767@mwanda>
References: <20120814145926.GA29090@elgon.mountain>
 <20120928113022.GW13767@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928113022.GW13767@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:30:22PM +0300, Dan Carpenter wrote:
> Whatever happened with this?  You could just change the GFP_KERNEL
> to GFP_ATOMIC.
> 

Ah, that email address is dead is what happened.  I'll send a patch
that changes this to GFP_ATOMIC.

regards,
dan carpenter

