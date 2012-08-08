Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2HHAMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:12:12 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58099 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab2HHAMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:12:09 -0400
X-Sasl-enc: z7CZXt3h+sHFzqf4KIL2ptGVXdxNsaI+wEmHqleZTOk0 1344384728
Date: Tue, 7 Aug 2012 17:12:07 -0700
From: "greg@kroah.com" <greg@kroah.com>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "smurf@smurf.noris.de" <smurf@smurf.noris.de>,
        "gustavo@padovan.org" <gustavo@padovan.org>,
        "Liuqifeng (Qifeng)" <qifeng.liuqifeng@huawei.com>
Subject: Re: [PATCH 1/8] USB:support the new interfaces of Huawei Data Card
 devices in option driver
Message-ID: <20120808001207.GC14456@kroah.com>
References: <910F9D9E13B84F4C8FA771DC9BDE99F326D85860@szxeml546-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F326D85860@szxeml546-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 02:05:18AM +0000, Fangxiaozhi (Franko) wrote:
> From: fangxiaozhi <huananhu@huawei.com> 
> 1. This patch is based on the kernel of 3.5 
> 2. In this patch, we add new micro for matching the series USB devices with vendor ID and interface information.
> 3. In this patch, we add new declarations into option.c to support the new interfaces of Huawei Data Card devices. And at the same time, remove the redundant declarations from option.c.
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
>  -----------------------

You say this is patch 1 of 8, where are the other 8 patches?

confused,

greg k-h
