Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2IJJ1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:27:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56342 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab2IJJ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:27:53 -0400
Message-ID: <504DB28D.3070005@ti.com>
Date: Mon, 10 Sep 2012 14:57:41 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Prabhakar Lad <prabhakar.lad@ti.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] ARM: da850/omap-l138: Add EVM specific code for
 VPIF to work
References: <1345471731-31678-1-git-send-email-prabhakar.lad@ti.com> <1345471731-31678-3-git-send-email-prabhakar.lad@ti.com> <504A2C7D.1090702@ti.com> <CA+V-a8sGhrTLJnthX+nZESvJfaHFTV=x06eXjQOwwCZwGBxkPQ@mail.gmail.com>
In-Reply-To: <CA+V-a8sGhrTLJnthX+nZESvJfaHFTV=x06eXjQOwwCZwGBxkPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 9/7/2012 11:04 PM, Prabhakar Lad wrote:
> On Fri, Sep 7, 2012 at 10:48 PM, Sekhar Nori <nsekhar@ti.com> wrote:

>>> +static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
>>> +#if defined(CONFIG_DA850_UI_SD_VIDEO_PORT)
>>
>> You agreed to get rid of these multiple ifdefs but you have not fixed that.
>>
> I have merged the top one, at later stage when we go  ahead and add sensor
> support then we would have require to have define two
> da850_vpif_capture_sdev_info
> so to avoid it I have kept this one.

Lets get to that when we actually add sensor support. It might make
sense then. Right now, there is no reason to have them.

Thanks,
Sekhar
