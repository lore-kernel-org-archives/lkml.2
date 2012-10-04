Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2JDL5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:57:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50360 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab2JDL5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:57:45 -0400
Message-ID: <506D79A3.4020506@ti.com>
Date: Thu, 4 Oct 2012 17:27:23 +0530
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
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v3 3/6] ARM: davinci: da850: changed SRAM allocator to
 shared ram.
References: <1349276133-26408-1-git-send-email-mporter@ti.com> <1349276133-26408-4-git-send-email-mporter@ti.com>
In-Reply-To: <1349276133-26408-4-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On 10/3/2012 8:25 PM, Matt Porter wrote:
> From: Subhasish Ghosh <subhasish@mistralsolutions.com>
> 
> This patch modifies the sram allocator to allocate memory
> from the DA8XX shared RAM.
> 
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> [rebased onto consolidated SRAM patches]
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> [rebased to mainline as consolidated SRAM patches were dropped]
> Signed-off-by: Matt Porter <mporter@ti.com>

Were you able to test PM with this change or you need my help?

Thanks,
Sekhar
