Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2LNKmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:42:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2LNKmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:42:07 -0500
From: Oliver Neukum <oneukum@suse.de>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>
Subject: Re: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage devices and support new switch command
Date: Fri, 14 Dec 2012 11:42:34 +0100
Message-ID: <6646955.7QFMbxFQIx@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8-12-desktop+; KDE/4.9.3; x86_64; ; )
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F326FC0242@szxeml546-mbs.china.huawei.com>
References: <fe8c905bb12.b12fe8c905b@huawei.com> <1758237.OLMhWhauCd@linux-lqwf.site> <910F9D9E13B84F4C8FA771DC9BDE99F326FC0242@szxeml546-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2012 10:28:31 Fangxiaozhi wrote:

Hi,

> > For such devices we should put the switching code into generic code, not a
> > device driver so that we have a chance to do reset_resume() on those
> > devices.
> --------------Because in many embedded linux system, they don't include such switch tools themselves. 
> 			So I think it is better to put the switching code in device driver.

Well, that argues for doing it in the kernel. Where you do it in the kernel shouldn't
matter.

> --------------By the way, because our device will response the switching command for once, 
> 			so I think you can do reset_resume() as you want.

What happens if S3 cuts power to the device?

	Regards
		Oliver

