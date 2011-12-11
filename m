Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1LKTFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 14:05:44 -0500
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:34869 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1LKTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 14:05:42 -0500
Message-ID: <4EE4FEF0.1090107@udo.edu>
Date: Sun, 11 Dec 2011 20:05:20 +0100
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111120 Thunderbird/8.0
MIME-Version: 1.0
To: wwguy <wey-yi.w.guy@intel.com>
CC: Udo Steinberg <udo@hypervisor.org>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlagn regression in v3.1.5
References: <4EE4AEF4.2080702@udo.edu> <4EE4DB55.4090804@udo.edu>  <20111211174138.79e51fe8@x220.fritz.box>  <4EE4E152.2070204@udo.edu> <1323627815.1806.19.camel@wwguy-ubuntu>
In-Reply-To: <1323627815.1806.19.camel@wwguy-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i haven't experienced firmware crushes, but after that commit i don't 
get any networking with my wlan card. I added some lspci and dmesg 
output to the patch. There was no strange output in my dmesg. dhcpcd 
says in logs, that carrier lost after about 30 seconds. How can i 
reproduce the HT40 bug?

Regards,
Andrej

On 12/11/2011 07:23 PM, wwguy wrote:
> On Sun, 2011-12-11 at 08:58 -0800, Andrej Gelenberg wrote:
>> Hi,
>>
>> this is pretty mean regression for the stable kernel. You may the fix
>> only for cards, which need it and not for all of them.
>
> Could you elaborate more on the failure case and setup. this patch is to
> address HT40 related problem which cause the iwlwifi firmware crash.
>
> Thanks
> Wey
>>>
>
>

