Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0IFP1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:27:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60932 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0IFP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:26:56 -0400
Message-ID: <4C850822.1080403@vlnb.net>
Date: Mon, 06 Sep 2010 19:26:26 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
References: <4C76CA57.3050405@vlnb.net>	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>	 <4C79484B.3090607@vlnb.net>	 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>	 <4C7C18CE.5020103@vlnb.net>	 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>	 <4C7FFD1A.8090509@vlnb.net>	 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>	 <20100905201802.GC18411@core.coreip.homeip.net>	 <1283723447.556.133.camel@haakon2.linux-iscsi.org>	 <20100905234134.GA17212@core.coreip.homeip.net>	 <1283731194.556.147.camel@haakon2.linux-iscsi.org>	 <1283769578.15944.1293.camel@mulgrave.site>	 <AANLkTikaE=7++X1VQj36Np93msyCViLs40_ti_2=ybqn@mail.gmail.com> <1283772443.15944.1320.camel@mulgrave.site>
In-Reply-To: <1283772443.15944.1320.camel@mulgrave.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:HI+/l91Jmiv+LLxopGijhOiwYNkPkw+zUVo95MdzWfg
 F+kPwTi61mTpMdWgMWZWXl4z3ThytQzSGpHqsJ+TYUm80vJD+2
 66dzpaMaDGAQjgjWD9dEFtyNbPIe2KJ3whDRFOP4hVuHHIaQkw
 6xPyKlzcNMhE0CVXXnYsc8BGVRCFFQZgsUqbhHZBP0umvuPZJP
 NPAlkotOzz3HE6KyJ3QXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley, on 09/06/2010 03:27 PM wrote:
> On Mon, 2010-09-06 at 13:02 +0200, Bart Van Assche wrote:
>> On Mon, Sep 6, 2010 at 12:39 PM, James Bottomley
>> <James.Bottomley@suse.de>  wrote:
>>>
>>> [ ... ]
>>>
>>>> So, please understand that code and project workflow is only one of the
>>>> reasons why TCM/LIO v4 was selected over SCST.
>>>
>>> It isn't yet ... your code still has to be reviewed properly.  My
>>> preferred reviewer is currently honing his skills on a diet of raw beef
>>> in Argentina, but hopefully he'll get around to it shortly.
>>
>> The SCST developers and the SCST users will definitely appreciate it
>> if review efforts will be spread evenly over both projects.
>
> SCST isn't at the starting gate yet, so there's nothing currently to
> review.

Hmm, there are patches for review for several months 
(http://lkml.org/lkml/2010/4/13/146). Nothing major changed since that time.

But we are going to send patches for the latest code this week anyway.

Vlad
