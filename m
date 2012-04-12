Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965887Ab2DLTZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:25:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44046 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969Ab2DLTZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:25:11 -0400
Message-ID: <4F872BED.7000703@ti.com>
Date: Thu, 12 Apr 2012 21:24:29 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: "Balbi, Felipe" <balbi@ti.com>, "Mohammed, Afzal" <afzal@ti.com>,
        Greg KH <greg@kroah.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "V, Aneesh" <aneesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
References: <1331934707-29487-1-git-send-email-aneesh@ti.com> <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com> <20120412030044.GA26236@kroah.com> <4F867A95.9030104@ti.com> <20120412131045.GB31384@kroah.com> <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com> <alpine.DEB.2.00.1204121053570.29473@utopia.booyaka.com> <4F87240F.6060902@ti.com> <alpine.DEB.2.00.1204121304050.29473@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1204121304050.29473@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 9:15 PM, Paul Walmsley wrote:
> Hi Benoît,
>
> On Thu, 12 Apr 2012, Cousson, Benoit wrote:
>
>> The LPDDR2 spec does consider as well NVM (Non Volatile Memory), so I think we
>> should stick to driver/memory for EMIF.
>
> Hmm good point!
>
>>> So perhaps something like drivers/memory/dram/ for the SDRAM controllers,
>>> and maybe drivers/memory/ for the GPMC?
>>
>> In fact Felipe was considering something else for that kind of general purpose
>> bus driver like GMPC, C2C and LLI...
>>
>> ... But I do not remember the name :-)
>
> It would be nice if we could separate IP blocks that can drive an Ethernet
> controller or modem chip from the DRAM controllers; they are quite
> different beasts from a common API standpoint.

Yep, fully agree. In fact Felipe's suggestion was something like 
drivers/ocd for off-chip devices, but maybe something like drivers/gpbus 
will highlight a little bit more the bus controller aspect of such driver.

Regards,
Benoit
