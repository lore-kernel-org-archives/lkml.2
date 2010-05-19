Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0ESRQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:16:04 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:55142 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869Ab0ESRQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:16:00 -0400
Message-ID: <4BF41CFD.6040004@ntlworld.com>
Date: Wed, 19 May 2010 18:16:45 +0100
From: Graham Ramsey <ramsey.graham@ntlworld.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: x86/pci Oops with CONFIG_SND_HDA_INTEL
References: <4BF40014.30303@ntlworld.com> <201005191044.05072.bjorn.helgaas@hp.com>
In-Reply-To: <201005191044.05072.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=W3tOLUehizD4qj6VhtReFuw5MKb8d+XqjIxlDsIazEA= c=1 sm=0 a=gXeVw4TqrbgA:10 a=ood2b7iyd8MA:10 a=8nJEP1OIZ-IA:10 a=VwQbUJbxAAAA:8 a=exhEdk1F75f6KmKp578A:9 a=AdKUfrGHFEX4u5plTtK0XSvwBAkA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/10 17:44, Bjorn Helgaas wrote:
> On Wednesday, May 19, 2010 09:13:24 am Graham Ramsey wrote:
>    
>> I am on x86_64 with latest (v2.6.34) kernel. When i set
>> CONFIG_SND_HDA_INTEL=Y It hangs at an early stage in boot with kernel oops.
>> When i use CONFIG_SND_HDA_INTEL=M the machine will boot, and i get the
>> dmesg (below).
>>
>> I have bisected down to one commit that causes the problem:
>>
>>     commit 3e3da00c01d050307e753fb7b3e84aefc16da0d0
>>     x86/pci: AMD one chain system to use pci read out res
>>     ...
>>      
> I CC'd Yinghai, the author of that patch.  That commit went in after
> 2.6.33, so this is probably a regression between .33 and .34.  Can
> you open a report at https://bugzilla.kernel.org and respond to this
> thread with the URL?
>
> Please attach the complete dmesg (with SND_HDA_INTEL=m) to the
> bugzilla.
>
> Thanks a lot for your report!
>
> Bjorn
>
>    
Done
https://bugzilla.kernel.org/show_bug.cgi?id=16007

