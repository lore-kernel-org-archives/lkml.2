Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab0I0G4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:56:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60459 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0I0G4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:56:06 -0400
Message-ID: <4CA03FFB.2030307@canonical.com>
Date: Mon, 27 Sep 2010 14:55:55 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Thunderbird/3.1.4
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: intel_idle (Lenovo ideapad S10-3)
References: <4C8DE00F.7070801@canonical.com> <alpine.LFD.2.00.1009251201150.17910@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1009251201150.17910@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Thanks a lot. I apply the patch and the kernel boots fine on S10-3


On 09/26/2010 12:09 AM, Len Brown wrote:
> 
>> I test myself which says when CONFIG_CPU_IDLE=y, Lenovo ideapad S10-3 can
>> not boot. The CPU is Atom N450, and I also find the report[2] that says intel_idle
>> works fine with N450.
>>
>> I do not have much knowledge about intel_idle. is there any similar report that on
>> some machine intel_idle halt the system or any suggestion for next step debug?
>>
>>
>> [1] http://launchpad.net/bugs/634702
>> [2] http://www.spinics.net/lists/linux-pm/msg21334.html
> 
> Please test the fix here:
> http://bugs.meego.com/show_bug.cgi?id=7093
> 
> thanks,
> -Len
> 

