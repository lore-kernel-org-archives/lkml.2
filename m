Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2JKKHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:07:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54925 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab2JKKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:07:38 -0400
Message-ID: <50769A45.5030105@ti.com>
Date: Thu, 11 Oct 2012 15:37:01 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <artem.bityutskiy@linux.intel.com>
CC: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "mikedunn@newsguy.com" <mikedunn@newsguy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "hs@denx.de" <hs@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [REMINDER: PATCH 1/1] mtd:nand:clk: preparation for switch to
 common clock framework
References: <1347899860-24358-1-git-send-email-m-karicheri2@ti.com> <1347899860-24358-2-git-send-email-m-karicheri2@ti.com> <3E54258959B69E4282D79E01AB1F32B7041EF679@DFLE12.ent.ti.com> <1349949469.20594.67.camel@sauron.fi.intel.com>
In-Reply-To: <1349949469.20594.67.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On 10/11/2012 3:27 PM, Artem Bityutskiy wrote:
> On Fri, 2012-09-28 at 16:10 +0000, Karicheri, Muralidharan wrote:
>>>> -----Original Message-----
>>>> From: Karicheri, Muralidharan
>>>> Sent: Monday, September 17, 2012 12:38 PM
>>>> To: dwmw2@infradead.org; artem.bityutskiy@linux.intel.com; hs@denx.de;
>>>> mikedunn@newsguy.com; linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org;
>>>> davinci-linux-open-source@linux.davincidsp.com; linux-arm-kernel@lists.infradead.org
>>>> Cc: Karicheri, Muralidharan
>>>> Subject: [PATCH 1/1] mtd:nand:clk: preparation for switch to common clock framework
> 
> I do not see this patch in my mailbox. Can you please re-send with all
> the acks?

This patch is already applied to linux-next. Do you need it still?

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=ea73fe7f0d562154975a77fe77ae3da6ab4d3e77

Thanks,
Sekhar
