Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2JDLyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:54:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50011 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab2JDLyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:54:01 -0400
Message-ID: <506D78BE.1000607@ti.com>
Date: Thu, 4 Oct 2012 17:23:34 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: [PATCH v3 2/6] ARM: davinci: da850-dm646x: remove the SRAM_VIRT
 iotable entry
References: <1349276133-26408-1-git-send-email-mporter@ti.com> <1349276133-26408-3-git-send-email-mporter@ti.com>
In-Reply-To: <1349276133-26408-3-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2012 8:25 PM, Matt Porter wrote:
> From: Ben Gardiner <bengardiner@nanometrics.ca>
> 
> The sram regions defined for da850-dm646x in their iotable entries are also
> defined in their davinci_soc_info's.
> 
> Remove this duplicate information which is now uneccessary since sram
> init will ioremap the regions defined by their davinci_soc_info's.
> 
> Since this removal completely removes all uses of SRAM_VIRT, also remove
> the SRAM_VIRT definition.
> 
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> Tested-by: Matt Porter <mporter@ti.com>

What testing was done with this patch? Can you please add that
information to the commit text as well.

Thanks,
Sekhar
