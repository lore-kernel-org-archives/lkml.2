Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0KDSKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:10:31 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:34911 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab0KDSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:10:29 -0400
Message-ID: <4CD2F715.9020108@mandriva.org>
Date: Thu, 04 Nov 2010 20:10:29 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kernel 2.6.33.7 (the highest version with RT patch) does not
 work with b44 ethernet controller
References: <4CD2BDE7.2070307@elka.pw.edu.pl> <4CD2C0F0.5030201@mandriva.org>
In-Reply-To: <4CD2C0F0.5030201@mandriva.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund skrev 4.11.2010 16:19:
> Wojtek Zabolotny skrev 4.11.2010 16:06:
>> I have updated my RT-kernel to version 2.6.33.7-rt29 (the newest RT
>> version),
>> and I've found that I've lost Ethernet connectivity.
>> In the logs I could see messages like this:
>> Nov 2 09:30:28 wzlaphp kernel: b44: eth0: powering down PHY
>> Nov 2 09:30:28 wzlaphp kernel: b44: eth0: BUG! Timeout waiting for bit
>> 00000002 of register 42c to clear.
>> Nov 2 09:30:32 wzlaphp kernel: b44: eth0: BUG! Timeout waiting for bit
>> 80000000 of register 428 to clear.
>>
>> I was not sure whether the probem is related to the 2.6.33.7 kernel
>> itself or with the RT patch, so I've compiled also the unpatched version
>> of 2.6.33.7
>>
>
> Known problem.
> It's the 2.6.33.7 kernel.
>
> You need to revert this:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=commit;h=6fb037c2ed8378c7ab0c1e00536ba6b2a866503e
>

Oh,
and if you need the alternate ssb eeprom addess fixes, you need to apply:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=commit;h=19bfed793ee38ce027326a3c518ff6201f673a8d
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=commit;h=3ca696ca403b2715018bd5c693ab105c3a3ea888
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=commit;h=a8515c84db1a9c9be19d8d873b059473474b6dab
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=commit;h=8235ddc2cd7a3367b688e0ed52ab377eac6cfad4


..
Thomas

