Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2HHALm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:11:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48417 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab2HHALh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:11:37 -0400
X-Sasl-enc: ycZCrvGVHW39Yut14cs1fXhgRwWjCtHPef1bFI1RpF4D 1344384696
Date: Tue, 7 Aug 2012 17:11:35 -0700
From: "greg@kroah.com" <greg@kroah.com>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "smurf@smurf.noris.de" <smurf@smurf.noris.de>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Liuqifeng (Qifeng)" <qifeng.liuqifeng@huawei.com>,
        Wangyeqi <wangyeqi@huawei.com>,
        "gustavo@padovan.org" <gustavo@padovan.org>
Subject: Re: [PATCH 7/26] USB:support the new interfaces of Huawei Data Card
 devices in option driver
Message-ID: <20120808001135.GB14456@kroah.com>
References: <910F9D9E13B84F4C8FA771DC9BDE99F326D712AA@szxeml546-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F326D712AA@szxeml546-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 08:44:33AM +0000, Fangxiaozhi (Franko) wrote:
> From: fangxiaozhi <huananhu@huawei.com> 
> 1. This patch is based on the kernel of 3.5
> 2. In this patch, we add new micro for matching the series USB devices with vendor ID and interface information.
> 3. In this patch, we add new declarations into option.c to support the new interfaces of Huawei Data Card devices. And at the same time, remove the redundant declarations from option.c.
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
>  -----------------------

Where are the other patches in this series?

Also, this patch does not apply to 3.6-rc1, please redo it.

greg k-h
