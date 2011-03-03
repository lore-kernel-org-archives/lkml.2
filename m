Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab1CCDnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:43:00 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:55990 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174Ab1CCDm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:42:59 -0500
Message-ID: <4D6F0E32.6050505@st.com>
Date: Thu, 3 Mar 2011 09:12:42 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        amitgoel <amit.goel@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/8 resend] dw_dmac: Remove compilation dependency from
 AVR32
References: <cover.1298889267.git.viresh.kumar@st.com>	 <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1298889267.git.viresh.kumar@st.com> <1299084372.6974.91.camel@vkoul-udesk3>
In-Reply-To: <1299084372.6974.91.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 10:16 PM, Koul, Vinod wrote:
> On Mon, 2011-02-28 at 16:11 +0530, Viresh Kumar wrote:
>> This will be used in SPEAr, ARM family.
> Does this mean it can be used on AVR32 now? Did you implay it will
> *also* be....

Yes, also be used in spear.

>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>> ---
>>  drivers/dma/Kconfig |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index 1c28816..95c7db7 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -82,7 +82,6 @@ config INTEL_IOP_ADMA
>>  
>>  config DW_DMAC
>>  	tristate "Synopsys DesignWare AHB DMA support"
>> -	depends on AVR32
> Shouldn't you be adding a corresponding depends on new arch? And since
> this supports old arch as well, it should say depends on both...

Why should this driver be dependent on ARM or AVR32? It can be present
on any other arch too.. So i thought removing this dependency all together
is better.
