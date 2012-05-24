Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2EXBZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:25:14 -0400
Received: from szxga04-in.huawei.com ([58.251.152.67]:45000 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755056Ab2EXBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:25:13 -0400
Date: Thu, 24 May 2012 09:24:48 +0800
From: Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [RESEND,PATCH] DCA, x86: fix invalid memory access in DCA core
In-reply-to: <436EC33EF05C3442BBF5497FC9483FF416274D2A@IRSMSX101.ger.corp.intel.com>
X-Originating-IP: [10.107.208.49]
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keping Chen <chenkeping@huawei.com>
Message-id: <4FBD8DE0.7070800@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222
 Thunderbird/9.0.1
X-CFilter-Loop: Reflected
References: <1336406288-9479-1-git-send-email-jiang.liu@huawei.com>
 <436EC33EF05C3442BBF5497FC9483FF41626EACA@IRSMSX101.ger.corp.intel.com>
 <4FAB20FB.6070508@gmail.com>
 <436EC33EF05C3442BBF5497FC9483FF4162732ED@IRSMSX101.ger.corp.intel.com>
 <4FB65D0E.9060004@gmail.com>
 <436EC33EF05C3442BBF5497FC9483FF416274D2A@IRSMSX101.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,
	Thanks for your help. Could you also help to review the IOAT
hotplug patch at http://www.spinics.net/lists/linux-pci/msg15287.html?
It's to support Intel IOAT device hotplug.
	Thanks!
On 2012-5-23 23:11, Sosnowski, Maciej wrote:
> On Fri, May 18, 2012 4:31 PM, Jiang Liu<liuj97@gmail.com>  wrote:
>>
>> On 05/18/2012 10:10 PM, Sosnowski, Maciej wrote:
>>> On Thu, May 07, May 10, 2012 3:59 AM, Jiang Liu<liuj97@gmail.com>  wrote:
>>>>
>>>> Hi Maciej,
>>>> 	I feel we may also need to tune the multiple IOH support in DCA.
>>>> Multiple IOH support is disabled for CB3.0 devices, how about CB3.1
>> devices
>>>> in Ivrbridge or SandyBridge? Does the hardware limitation still exist? Or
>>>> could we support multiple IOHs with IvyBridge and SandyBridge?
>>>> 	If multiple IOH is supported, I think we should move the logic to
>>>> disable multiple IOH support for CB3.0 from DCA core into ioatdma. I have
>>>> also prepared two patches for that two.
>>>> 	Thanks!
>>>>
>>>
>>> At this point I do not think we would need to tune multiple IOH for DCA.
>>> The limitation you mention applies only to CB3.0. I do not think DCA is
>> supported
>>> with Sandy Bridge / Ivy Bridge regardless of multi-IOH case but let me
>> confirm it
>>> yet.
>> It seems that Intel introduces DDIO technology for IvyBridge. Does it replace
>> DCA
>> technology on new platforms?
>> Thanks!
>
> Yes, in general DDIO is used instead of DCA on new platforms.
> Note however that DDIO is supported in Xeon E5 only, not in Xeon E3.
>
> Thanks,
> Maciej
>
>


