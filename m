Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1HDB5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:57:13 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49947 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab1HDB5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:57:05 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p741ui1E003311, This message is released by code: ctaloc0852
X-BOX-Message-Id: p741ui1E003311
Message-ID: <4E39FBC8.8070702@realsil.com.cn>
Date: Thu, 4 Aug 2011 09:54:16 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rts_pstor:modify thread synchronization flow
References: <1312358425-8442-1-git-send-email-wei_wang@realsil.com.cn> <20110803153937.GB3479@kroah.com>
In-Reply-To: <20110803153937.GB3479@kroah.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011Äê08ÔÂ03ÈÕ 23:39, Greg KH wrote:
> On Wed, Aug 03, 2011 at 04:00:25PM +0800, wei_wang@realsil.com.cn wrote:
>> From: wwang <wei_wang@realsil.com.cn>
>>
>> Using different completion variables to synchronize different kernel threads
>>
>> Signed-off-by: wwang <wei_wang@realsil.com.cn>
> Is this fixing a bug that is seen now, or is this just a nice "cleanup"
> patch that can wait for the 3.2 kernel release?
>
> thanks,
>
> greg k-h
This patch fix a bug that may cause memory leak when driver
disconnected. This is not a very urgent bug. Because with the default
setting, driver disconnectting routine won't be called except when Linux
is shut down. But if the option auto_delink_en is set, a small number of
memory would leak out after memory card unplugged.

Best regards,
wwang
