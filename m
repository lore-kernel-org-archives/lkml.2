Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030870Ab2CFO5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:57:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:53559 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759244Ab2CFO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:57:09 -0500
Message-ID: <4F5625B3.9020400@windriver.com>
Date: Tue, 6 Mar 2012 09:56:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the moduleh tree with the usb tree
References: <20120306165053.c42cdb7ff8e6772a0a8ebbd5@canb.auug.org.au>
In-Reply-To: <20120306165053.c42cdb7ff8e6772a0a8ebbd5@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-06 12:50 AM, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the moduleh tree got a conflict in
> drivers/usb/dwc3/dwc3-omap.c between commit 45b3cd4ad79b ("usb: dwc3:
> omap: convert pdata to of property") from the usb tree and commit
> 13ae246db4a0 ("includecheck: delete any duplicate instances of module.h")
> from the moduleh tree.
> 
> Just context changes.  I fixed it up and can carry the fix as necessary.

Thanks Stephen,

I had a look and the instance being deleted is really the right
one to delete, so this conflict will have to stay carried it seems.

Paul.
