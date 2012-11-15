Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab2KOAdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:33:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42799 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2KOAdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:33:00 -0500
Message-ID: <50A43828.6000702@oracle.com>
Date: Thu, 15 Nov 2012 08:32:40 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Dave, Tushar N" <tushar.n.dave@intel.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
Subject: Re: 82571EB: Detected Hardware Unit Hang
References: <509B5038.8090304@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com> <50A30656.6090508@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA8913348B105@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <061C8A8601E8EE4CA8D8FD6990CEA8913348B105@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/12 11:45, Dave, Tushar N wrote:
>> -----Original Message-----
>> From: Joe Jin [mailto:joe.jin@oracle.com]
>> Sent: Tuesday, November 13, 2012 6:48 PM
>> To: Dave, Tushar N
>> Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Mary Mcgrath
>> Subject: Re: 82571EB: Detected Hardware Unit Hang
>>
>> On 11/09/12 04:35, Dave, Tushar N wrote:
>>> All devices in path from root complex to 82571, should have *same* max
>> payload size otherwise it can cause hang.
>>> Can you double check this?
>>
>> Hi Tushar,
>>
>> Checked with hardware vendor and they said no way to modify the max
>> payload size from BIOS, can I modify it from driver side?
> 
> If you want to change value for 82571 device you can do it from eeprom but for other upstream devices I am not sure. I will check with my team.

Hi Tushar,

Would you please help to fine the offset of max payload size in eeprom?
I'd like to have a try to modify it by ethtool.

Thanks in advance,
Joe
