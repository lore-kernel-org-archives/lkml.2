Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1HCN2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:28:24 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:36377 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764Ab1HCN2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:28:16 -0400
Message-ID: <4E394CC0.7050208@stericsson.com>
Date: Wed, 3 Aug 2011 15:27:28 +0200
From: =?ISO-8859-1?Q?Per_F=F6rlin?= <per.forlin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: "balbi@ti.com" <balbi@ti.com>
Cc: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] usb: musb: ux500: replace missing DBG with dev_dbg
References: <1312374137-10629-1-git-send-email-per.forlin@stericsson.com> <20110803131749.GL11080@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110803131749.GL11080@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 03:17 PM, Felipe Balbi wrote:
> On Wed, Aug 03, 2011 at 02:22:17PM +0200, Per Forlin wrote:
>> From: Per Forlin <per.forlin@linaro.org>
>>
>> ux500_dma.c fail to compile becase DBG has been removed from musb_debug.
>> Use dev_dbg for all prints.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>
> 
> applied, thanks. Let me know if this should go to stable and I can make
> sure of adding stable to the Cc list.
> 
I checked v3.0, and both ux500_dma and cppi_dma use DBG. These two files wont build in v3.0. Please CC stable.

I am about to send patch to fix cppi_dma as well. Should I CC stable when I post it?

/Per

