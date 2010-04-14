Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0DNOSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:18:49 -0400
Received: from nat.nue.novell.com ([195.135.221.3]:60270 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753134Ab0DNOSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:18:48 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2010 10:18:48 EDT
Message-ID: <4BC5CA13.3070801@suse.de>
Date: Wed, 14 Apr 2010 17:58:43 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100404 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tero Roponen <tero.roponen@gmail.com>
CC: Luca Tettamanti <kronos.it@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, len.brown@intel.com
Subject: Re: [acpi:battery?] kernel oops on boot
References: <20100414095750.GA3304@swordfish.minsk.epam.com> <20100414131324.GA6598@nb-core2.darkstar.lan> <alpine.LFD.2.00.1004141641010.3640@terrop>
In-Reply-To: <alpine.LFD.2.00.1004141641010.3640@terrop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14.04.2010 17:50, Tero Roponen пишет:
>
> On Wed, 14 Apr 2010, Luca Tettamanti wrote:
>
>> Hello,
>> I'm seeing a similar bug on my notebook (Asus F3Sa) with current git.
>> -rc4 does not work, while -rc3 does work.
>>
>> The error (at least in my case) is a division by zero in
>> acpi_ex_insert_into_field.
>
> I have a similar problem with Asus M50Vm. git-bisect found
> the following commit and reverting it does indeed fix the
> problem.
>
> commit dadf28a10c3eb29421837a2e413ab869ebd9e168
> Author: Alexey Starikovskiy<astarikovskiy@suse.de>
> Date:   Wed Mar 17 13:14:13 2010 -0400
>
>      ACPI: EC: Allow multibyte access to EC
>
>      http://bugzilla.kernel.org/show_bug.cgi?id=14667
>
>      Signed-off-by: Alexey Starikovskiy<astarikovskiy@suse.de>
>      Signed-off-by: Len Brown<len.brown@intel.com>
>
Please see the patch in https://bugzilla.kernel.org/show_bug.cgi?id=15749

Thanks,
Alex.


