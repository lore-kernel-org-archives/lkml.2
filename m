Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1EAMhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 08:37:11 -0400
Received: from filoni2.nine.ch ([94.230.212.32]:42058 "EHLO mail.lenux.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1EAMhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 08:37:09 -0400
Message-ID: <4DBD53F6.6070603@docs.homelinux.org>
Date: Sun, 01 May 2011 14:37:10 +0200
From: root <root@docs.homelinux.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Error in Hyper-V modules hv_vmbus
References: <4DBC1F2F.5050205@docs.homelinux.org> <6E21E5352C11B742B20C142EB499E0481DF19C@TK5EX14MBXC124.redmond.corp.microsoft.com>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DF19C@TK5EX14MBXC124.redmond.corp.microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>> -----Original Message-----
>> From: root [mailto:root@docs.homelinux.org]
>> Sent: Saturday, April 30, 2011 10:40 AM
>> To: linux-kernel@vger.kernel.org; KY Srinivasan
>> Subject: Error in Hyper-V modules hv_vmbus
>>
>> Hello
>>
>> I have compiled and installed the new 2.6.39-rc5 linux kernel with
>> Microsoft Hyper-V modules enabled on my Debian Squeeze system. After a
>> reboot I get these errors (sorry can post only screenshots because I
>> can't copy the log):
> What is the version of the Windows host. I have seen some issues with
> older hosts, where the vmbus driver does not get the correct irq. I have
> submitted a patch for this (this is yet to be applied by Greg).
>
> Regards,
>
> K. Y
>

Windows Server Core 2008 R2 with SP2

Regards
Juan Dos Santos
