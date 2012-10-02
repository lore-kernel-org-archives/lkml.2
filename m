Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab2JBIjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:39:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47349 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab2JBIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:39:06 -0400
Date: Tue, 2 Oct 2012 11:38:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net, 3/3] hyperv: Fix page buffer handling in
 rndis_filter_send_request()
Message-ID: <20121002083847.GR4587@mwanda>
References: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
 <1349130657-7987-3-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349130657-7987-3-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 03:30:57PM -0700, Haiyang Zhang wrote:
> Add another page buffer if the request message crossed page boundary.
> 

What are the user visible effects of this bug fix?  Please put that
in the commit message.

regards,
dan carpenter

