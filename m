Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2L2Anm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 19:43:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39789 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab2L2Ani (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 19:43:38 -0500
Message-ID: <50DE3CB9.10409@wwwdotorg.org>
Date: Fri, 28 Dec 2012 17:43:37 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V7 2/7] ARM: dt: change .dtb build rules to build in dts
 directory
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org> <1354058956-7199-2-git-send-email-swarren@wwwdotorg.org> <20121226142739.GA28980@S2101-09.ap.freescale.net>
In-Reply-To: <20121226142739.GA28980@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 07:27 AM, Shawn Guo wrote:
> On Tue, Nov 27, 2012 at 04:29:11PM -0700, Stephen Warren wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>>
>> The current rules have the .dtb files build in a different directory
>> from the .dts files. The only reason for this is that it was what
>> PowerPC has done historically. This patch changes ARM to use the generic
>> dtb rule which builds .dtb files in the same directory as the source .dts.
>
> It's a pity that after merging the patch, all the enabled dts files
> will be rebuilt anyway no matter whether they are actually changed
> or not.

Oops. I thought I'd tested that quite extensively, but I somehow missed
something. I've sent patches to fix this.

