Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170Ab2JaTQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:16:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47837 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759793Ab2JaTQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:16:50 -0400
Message-ID: <5091791F.4080400@wwwdotorg.org>
Date: Wed, 31 Oct 2012 13:16:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 0/4] ARM: tegra: Enable SLINK controller driver
References: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com> <50915203.8030505@wwwdotorg.org> <5091607D.8010907@nvidia.com>
In-Reply-To: <5091607D.8010907@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 11:31 AM, Laxman Dewangan wrote:
> On Wednesday 31 October 2012 09:59 PM, Stephen Warren wrote:
>> On 10/31/2012 03:02 AM, Laxman Dewangan wrote:
>>> This series modify the dts file to add the slink addresses,
>>> make AUXDATA in board dt files, enable slink4 for tegra30-cardhu and
>>> enable slink controller defconfig.
>> I don't appear to have received patch 1/4 this time around. I'll assume
>> it's identical to V3, since I don't think anything needed to change
>> there...
> 
> Yes, it is identical to V3, no change on the 1/4.

OK, I have applied the series now. Thanks.

BTW, I noticed that the Cardu board files sets the SPI controller's max
frequency to 25MHZ (which is consistent with the commit description) but
the SPI flash node's frequency to 20MHz. Was that intended, or should I
fix it up to be 25MHz?

> Only change in 3/4 and 4/4. I realize later that you already applied the
> 2/4 yesterday.

Oops, that was a mistake; I forgot to pull it out after testing and not
getting it to work. Oh well.
