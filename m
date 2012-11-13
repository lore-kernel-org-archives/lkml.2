Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2KMR5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:57:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45803 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab2KMR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:57:01 -0500
Message-ID: <50A289E8.4030407@gmail.com>
Date: Tue, 13 Nov 2012 09:56:56 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Jonas Gorski <jonas.gorski@gmail.com>, linux-mips@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org,
        Kevin Cernekee <cernekee@gmail.com>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [RFC] MIPS: BCM63XX: add simple Device Tree includes for all
 SoCs
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com> <1352638249-29298-3-git-send-email-jonas.gorski@gmail.com> <50A1D290.3050409@wwwdotorg.org>
In-Reply-To: <50A1D290.3050409@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 08:54 PM, Stephen Warren wrote:
> On 11/11/2012 05:50 AM, Jonas Gorski wrote:
>> Add simple Device Tree include files for all currently supported SoCs.
>> These will be populated with device definitions as driver support
>> gets added.
>
>>   arch/mips/bcm63xx/dts/bcm6328.dtsi |   30 ++++++++++++++++++++++++++++++
>>   arch/mips/bcm63xx/dts/bcm6338.dtsi |   30 ++++++++++++++++++++++++++++++
>>   arch/mips/bcm63xx/dts/bcm6345.dtsi |   30 ++++++++++++++++++++++++++++++
>>   arch/mips/bcm63xx/dts/bcm6348.dtsi |   30 ++++++++++++++++++++++++++++++
>>   arch/mips/bcm63xx/dts/bcm6358.dtsi |   33 +++++++++++++++++++++++++++++++++
>>   arch/mips/bcm63xx/dts/bcm6368.dtsi |   33 +++++++++++++++++++++++++++++++++
>
> All of ARM, c6x, microblaze, openrisc, powerpc put device tree files
> into arch/${arch}/boot/dts/ - should MIPS follow the same layout?

At this point, I don't see what the benefit of centralizing all of these 
would be.  Currently there is no concept of a single kernel image that 
would work across multiple MIPS system implementations.  So keeping the 
DTS files with their users makes some organizational sense.

Similar arguments could be made for moving all the files in `find . 
-name \*.dts\*` to a top level dts/ directory.

David Daney
