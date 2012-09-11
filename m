Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab2IKLbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:31:17 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36982 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759166Ab2IKLbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:31:15 -0400
Message-ID: <504F20FA.7020003@ti.com>
Date: Tue, 11 Sep 2012 17:01:06 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        Greg KH <gregkh@linuxfoundation.org>, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-serial@vger.kernel.org, Sourav Poddar <sourav.poddar@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        alan@linux.intel.com
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
References: <20120906122948.GC29202@arwen.pp.htv.fi> <1346935540-1792-1-git-send-email-balbi@ti.com> <87harahiv6.fsf@deeprootsystems.com> <20120907054932.GB3136@arwen.pp.htv.fi> <87oblhmu6g.fsf@deeprootsystems.com> <20120908190423.GA14771@arwen.pp.htv.fi>
In-Reply-To: <20120908190423.GA14771@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 September 2012 12:34 AM, Felipe Balbi wrote:
>> In addition, IMO, if this was only tested on Panda (as suggested by
>> > earlier cover letters), it really should not have been merged until it
>> > got some broader testing.
> Shubhro's got his Tested-by tag. I believe he tested on beagleboard and
> omap4sdp. Shubhro, can you confirm which platforms you tested the UART
> patches ? cheers
Felipe I had boot tested on omap3sdp and onap4 sdp and did pm testing
on both with omap3 hitting off.

