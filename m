Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2GODxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 23:53:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24946 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2GODw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 23:52:59 -0400
Message-ID: <50023E88.4030004@oracle.com>
Date: Sun, 15 Jul 2012 11:52:40 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Dave, Tushar N" <tushar.n.dave@intel.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 82571EB: Detected Hardware Unit Hang
References: <4FFA9B96.6040901@oracle.com> <4FFCF314.6020400@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EEDD7@ORSMSX102.amr.corp.intel.com> <4FFD0908.6080506@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EF8AD@ORSMSX102.amr.corp.intel.com> <4FFE3505.8060407@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F018D@ORSMSX102.amr.corp.intel.com> <4FFE3D27.7020500@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F01BE@ORSMSX102.amr.corp.intel.com> <4FFE40A9.4060807@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F02D7@ORSMSX102.amr.corp.intel.com> <4FFE6BB9.4060106@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F033B@ORSMSX102.amr.corp.intel.com> <4FFE787B.9050201@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F0ACC@ORSMSX102.amr.corp.intel.com> <4FFF61BD.1060604@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F11FF@ORSMSX102.amr.corp.intel.com> <4FFFA532.1030208@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F2354@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <061C8A8601E8EE4CA8D8FD6990CEA891274F2354@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/12 11:42, Dave, Tushar N wrote:
>> -----Original Message-----
>> From: Joe Jin [mailto:joe.jin@oracle.com]
>> Sent: Thursday, July 12, 2012 9:34 PM
>> To: Dave, Tushar N
>> Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: 82571EB: Detected Hardware Unit Hang
>>
>> On 07/13/12 12:10, Dave, Tushar N wrote:
>>>> -----Original Message-----
>>>> From: Joe Jin [mailto:joe.jin@oracle.com]
>>>> Sent: Thursday, July 12, 2012 4:46 PM
>>>> To: Dave, Tushar N
>>>> Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>>>> kernel@vger.kernel.org
>>>> Subject: Re: 82571EB: Detected Hardware Unit Hang
>>>>
>>> Thanks for sending full dmesg log. I am still investigating. I think
>> this issue can occur if two PCIe link partner *i.e pcie bridge and pcie
>> device do not have same max payload size.
>>> I need 2 more info.
>>> 1) PBA number of the card.
>>
>> This is a remote server and I could not get this.
>>
>>> 2) full lspci -vvv output of entire system 'after you have changed max
>> payload size to 128'.
> 
> Somehow setting max payload to 256 from BIOS does not set this value for all devices. I believe this is a BIOS bug.
> All devices in path from root complex to 82571, should have same max payload size otherwise it can cause hang. When you set max payload to 128 from BIOS, all device in path from root complex to 82571 got assigned same max payload size. This resolves the issue.
> 
> I hope this helps.

Tushar,

Thanks a lot for your help, will send this to hardware engineer.

Regards,
Joe

