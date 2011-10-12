Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1JLNtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:49:41 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:54453 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753342Ab1JLNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:49:37 -0400
Message-ID: <4E959A9B.7060100@ru.mvista.com>
Date: Wed, 12 Oct 2011 17:48:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
In-Reply-To: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 04:36 PM, Markus Rechberger wrote:

> We have 2 products which can perform better with increased Bulk transfers

> Device No. 1:
> According to the hardware spec of on of our product
> Available Bulk Transfer Size are:
> - 188 * n bytes, where n = 1 ~ 256.

> Although we can drive that one with 15K as well when setting the HW
> register down to it.

> Device No. 2
> only creates jitter video with Bulk transfer sizes which are below
> 24064 bytes, no such chipfeature is available
> to decrease the bulk transfer size.
> http://sundtek.de/images/dtvjitter2.jpg
> with transfer size of 24064:
> http://sundtek.de/images/gooddata.jpg

> The patch takes the features of Device No. 1 into account allowing a
> maximum buffer of 48128 bytes.

> Those issues have been evaluated with MacOSX and a customized patched
> Linux version.
> Device No. 2 also corrupts on MacOSX with too small packet sizes,
> Windows and Mac are using 24064 bytes.

    You are constantly mixing the packet size and the transfer size.

> Default Bulk Transfersize of device No. 1 is around 1-2k which leads
> to very high cpu usage, updating it to 15k lowers that one.

WBR, Sergei
