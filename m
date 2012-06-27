Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2F0AeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:34:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42404 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2F0AeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:34:20 -0400
Message-ID: <4FEA5509.7040000@wwwdotorg.org>
Date: Tue, 26 Jun 2012 18:34:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DT fixes for 3.5
References: <4FDA9261.2070208@gmail.com> <4FEA47EA.3000804@gmail.com>
In-Reply-To: <4FEA47EA.3000804@gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 05:38 PM, Rob Herring wrote:
> On 06/14/2012 08:39 PM, Rob Herring wrote:
>> Grant,
>>
>> Please pull. Mainly some documentation updates and 2 fixes:
>>
>> - An export symbol fix for of_platform_populate from Stephen W.
>> - A fix for the order compatible entries are matched to ensure the
>> first compatible string is matched when there are multiple matches.
>>
> 
> Ping. If you don't want to pull these for 3.5, can you please pull for
> next and 3.6.

The of_platform_populate() patch of mine is needed in 3.5 to solve a
build problem there, if the Tegra AHUB driver is built as a module
(which admittedly it isn't in tegra_defconfig, but anyway).
