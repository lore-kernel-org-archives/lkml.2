Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2EROaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:30:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39655 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2EROau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:30:50 -0400
Message-ID: <4FB65D0E.9060004@gmail.com>
Date: Fri, 18 May 2012 22:30:38 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keping Chen <chenkeping@huawei.com>
Subject: Re: [RESEND,PATCH] DCA, x86: fix invalid memory access in DCA core
References: <1336406288-9479-1-git-send-email-jiang.liu@huawei.com> <436EC33EF05C3442BBF5497FC9483FF41626EACA@IRSMSX101.ger.corp.intel.com> <4FAB20FB.6070508@gmail.com> <436EC33EF05C3442BBF5497FC9483FF4162732ED@IRSMSX101.ger.corp.intel.com>
In-Reply-To: <436EC33EF05C3442BBF5497FC9483FF4162732ED@IRSMSX101.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 10:10 PM, Sosnowski, Maciej wrote:
> On Thu, May 07, May 10, 2012 3:59 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>
>> Hi Maciej,
>> 	I feel we may also need to tune the multiple IOH support in DCA.
>> Multiple IOH support is disabled for CB3.0 devices, how about CB3.1 devices
>> in Ivrbridge or SandyBridge? Does the hardware limitation still exist? Or
>> could we support multiple IOHs with IvyBridge and SandyBridge?
>> 	If multiple IOH is supported, I think we should move the logic to
>> disable multiple IOH support for CB3.0 from DCA core into ioatdma. I have
>> also prepared two patches for that two.
>> 	Thanks!
>>
> 
> At this point I do not think we would need to tune multiple IOH for DCA.
> The limitation you mention applies only to CB3.0. I do not think DCA is supported
> with Sandy Bridge / Ivy Bridge regardless of multi-IOH case but let me confirm it
> yet.
It seems that Intel introduces DDIO technology for IvyBridge. Does it replace DCA
technology on new platforms?
Thanks!

> 
> Thanks,
> Maciej

