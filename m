Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1HJVbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:31:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51972 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab1HJVbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:31:33 -0400
Message-ID: <4E42F8AD.5050000@ti.com>
Date: Wed, 10 Aug 2011 22:31:25 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jin Park <jinyoungp@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2 RESEND] regulator: aat2870: Fix the logic of checking
 if no id is matched in aat2870_get_regulator
References: <1309995504.2496.1.camel@phoenix> <CAF+7xW=AXA9RgddR0HgFwWdRcy6v1hcDXc7Z7KXb1DTBuzH-Pg@mail.gmail.com> <1311955847.2712.12.camel@CNA0741383> <CAF+7xWkUO0d7Bp4a8-0cksZhhcQ-jb4XfRCEP=qCqb3_qb5RxQ@mail.gmail.com>
In-Reply-To: <CAF+7xWkUO0d7Bp4a8-0cksZhhcQ-jb4XfRCEP=qCqb3_qb5RxQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 16:19, Axel Lin wrote:
> 2011/7/30 Liam Girdwood <lrg@ti.com>:
>> On Fri, 2011-07-29 at 18:05 +0200, Axel Lin wrote:
>>> hi,
>>> Seems this 2 patches are not upstream. Should I resend it again?
>>> Regards,
>>> Axel
>>
>> Not required atm thanks, this driver went via mfd so I can apply the fix
>> after the mfd merge or rc1.
> hi Liam,
> aat2870-regulator.c is already merged to your tree but
> seems these 2 patches are not (yet) upstream.
> 

Could you check regulator git #for-linus. I applied a bunch of patches a few days ago and some for this device. I'll do a pull request for rc2 in a few days.

Thanks

Liam 
