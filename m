Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2CBVir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:38:47 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42688 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756893Ab2CBVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:38:45 -0500
X-Sasl-enc: C1pwEMLA+ekPJ/obu3z/2DSm5oxfR4jeQGcsaq7SMi5V 1330724324
Message-ID: <4F513DE3.9020707@signal11.us>
Date: Fri, 02 Mar 2012 16:38:43 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] ARM: Tegra: cleanup patches from Arnd Bergmann
References: <1330721884-8495-1-git-send-email-alan@signal11.us> <74CDBE0F657A3D45AFBB94109FB122FF17BE861A54@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE861A54@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 04:04 PM, Stephen Warren wrote:
> Alan Ott wrote at Friday, March 02, 2012 1:58 PM:
>> Sorry for the mess yesterday....
>> This is V2 of Arnd's Patch series from yesterday. Hopefully this one will be
>> smoother.
> There was feedback on at least patches 4 and 5 that doesn't appear to
> have been incorporated into this updated version.

Hi Stephen,

For patch #4 (ARM: tegra: work around tegra THUMB2_KERNEL bug) I missed
the last email in that series. I'm sorry, I'll drop this patch from v3.

For patch #5 (ARM: tegra: USB_ULPI needs USB), it didn't look to me like
there was a resolution on that thread yesterday. On reading it again, if
we change
    select USB_ULPI if USB_SUPPORT
to:
    select USB_ULPI if USB
for both Tegra 2 and 3, does that satisfy you and Arnd?

Thanks for catching these Stephen.

Alan.



