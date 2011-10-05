Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935135Ab1JERJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:09:24 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:38618 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935070Ab1JERJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:09:22 -0400
Message-ID: <4E8C8F3D.8040605@xenotime.net>
Date: Wed, 05 Oct 2011 10:09:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, rmody@brocade.com,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        huangj@brocade.com, adapter_linux_open_src_team@brocade.com,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [net-next 1/1] bna: Multiple Definition and Interface Setup Fix
References: <1317781880-26515-1-git-send-email-rmody@brocade.com>	<20111004.232713.1345786533613742751.davem@davemloft.net> <20111005192601.fa947a78b188f4a021042a5e@canb.auug.org.au>
In-Reply-To: <20111005192601.fa947a78b188f4a021042a5e@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/11 01:26, Stephen Rothwell wrote:
> On Tue, 04 Oct 2011 23:27:13 -0400 (EDT) David Miller <davem@davemloft.net> wrote:
>>
>> From: Rasesh Mody <rmody@brocade.com>
>> Date: Tue, 4 Oct 2011 19:31:20 -0700
>>
>>> drivers/net/built-in.o: In function `bfa_ioc_ct2_poweron':
>>> (.text+0xcdc90): multiple definition of `bfa_ioc_ct2_poweron'
>>> drivers/scsi/built-in.o:(.text+0x17f9a0): first defined here
>>>
>>> This patch renames bfa_ioc_ct2_poweron() to bfa_nw_ioc_ct2_poweron() to avoid
>>> multiple definition with Brocade scsi driver. It also modifies asic specific
>>> interface setup to allocate MSIX resources at power on in case of 1860 HW with
>>> no asic block and warns if the asic gen is neither BFI_ASIC_GEN_CT nor
>>> BFI_ASIC_GEN_CT2.
>>>
>>> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
>>> Signed-off-by: Rasesh Mody <rmody@brocade.com>
>>
>> Applied, thanks.

Thanks for the patch.

> I also manually applied this to linux-next today.

We could also stand to have this patch applied to linux-next since
it doesn't seem to be merged anywhere else yet: (for drivers/media/video)

http://marc.info/?l=linux-next&m=131741851601754&w=2


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
