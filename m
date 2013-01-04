Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3ADCsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 21:48:04 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:55375 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3ADCsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 21:48:01 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r042kMQq006942, This message is released by code: ctaloc0852
Message-ID: <50E6427E.1050809@realsil.com.cn>
Date: Fri, 4 Jan 2013 10:46:22 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "oakad@yahoo.com" <oakad@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v3 3/8] MFD:rtsx: Declare that the DMA address limitationis32bit explicitly
References: <cover.1356662293.git.wei_wang@realsil.com.cn> <cd92be49bee917165009311d62e10a5f60a85a48.1356662293.git.wei_wang@realsil.com.cn> <20130103122559.GF7247@mwanda>
In-Reply-To: <20130103122559.GF7247@mwanda>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年01月03日 20:25, Dan Carpenter 写道:
> On Fri, Dec 28, 2012 at 10:41:28AM +0800, wei_wang@realsil.com.cn wrote:
>> From: Wei WANG <wei_wang@realsil.com.cn>
>>
>> Realtek PCIe card reader only supports 32bit DMA
>>
> Is this a bugfix?  If so what does the bug look like?
>
> regards,
> dan carpenter
>
Hi Dan:

No, this is not a bugfix. In default, the kernel will allocate 32bit
address for DMA. This declaration can improve the readability.

BR,
wei wang
