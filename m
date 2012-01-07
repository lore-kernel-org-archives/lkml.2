Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2AGUdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 15:33:35 -0500
Received: from lo.gmane.org ([80.91.229.12]:50751 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2AGUde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 15:33:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gene Smith <gds@chartertn.net>
Subject: Re: wifi iwlagn fails to authenticate after wake from suspend
Date: Sat, 07 Jan 2012 15:33:17 -0500
Message-ID: <jeaa6d$5hj$1@dough.gmane.org>
References: <j881g5$tdf$1@dough.gmane.org>  <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>  <j8fvka$fu0$1@dough.gmane.org>  <CA+tb8OUHNbhVN_KiEkqXJW1apFoExRM5Vrn=ES5SF3sFoGOMfA@mail.gmail.com> <1323701322.1806.24.camel@wwguy-ubuntu> <jdqq44$7d9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 24-158-184-117.dhcp.jcsn.tn.charter.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
In-Reply-To: <jdqq44$7d9$1@dough.gmane.org>
Cc: linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2012 06:26 PM, Gene Smith wrote:
>> On 12/12/2011 09:48 AM, wwguy wrote:

>> try the following module parameter and see if help
>>
>> $sudo modprobe iwlagn bt_coex_active=0
>>
>> Thanks
>> Wey
>>
>
> Unfortunately the latest fedora 16 kernel, 3.1.6-1.fc16.x86_64, renders
> this fix
> ineffective and again cannot resume wifi after a sleep and must reboot.
> Therefore must stay with older kernels for this to work and for wifi to
> resume
> after sleep:
> 3.1.5-6.fc16 is still OK with bt_coex_active=0
> 3.1.5-2.fc16 is also still OK with this fix.

The kernel 3.1.6-1.fc16.x86_64 now uses wireless driver called iwlwifi and
not  iwlagn. I was not setting the parameter correctly. When I do this

modprobe iwlwifi bt_coex_active=0

the workaround is still OK and wireless reconnects after sleep.



