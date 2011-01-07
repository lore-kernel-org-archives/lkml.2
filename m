Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1AGIxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:53:37 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:56611 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab1AGIxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:53:35 -0500
Message-ID: <4D26D4E1.6050609@st.com>
Date: Fri, 7 Jan 2011 14:24:57 +0530
From: pratyush <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Viresh KUMAR <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] ST SPEAr: PCIE gadget suppport
References: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com> <20110106121853.016fb990.akpm@linux-foundation.org>
In-Reply-To: <20110106121853.016fb990.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/2011 1:48 AM, Andrew Morton wrote:
> On Thu, 6 Jan 2011 17:29:10 +0530
> Viresh Kumar <viresh.kumar@st.com> wrote:
> 
>> From: Pratyush Anand <pratyush.anand@st.com>
>>
>> This is a configurable gadget. can be configured by sysfs interface. Any
>> IP available at PCIE bus can be programmed to be used by host
>> controller.It supoorts both INTX and MSI.
>> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
>> with size 0x1000
>>
>> ...
>>
>> --- /dev/null
>> +++ b/Documentation/misc-devices/spear-pcie-gadget.txt
> 
> Please recheck this documentation file - it contains a number of simple
> typos.
> 

will check that and send PATCH V3.
 
>>
>> ...
>>
>> +	if (strict_strtoul(buf, 0, &config->requested_msi))
>> +		return -EINVAL;
> 
> It doesn't matter much, but the code really should propagate the
> strict_strtoul() return error code back to the caller, rather than
> overwriting it with -EINVAL.
> 

will do that modification in PATCH V3.

Regards
Pratyush

> .
> 

