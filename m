Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1KVGsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:48:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51678 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab1KVGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:48:21 -0500
MIME-Version: 1.0
In-Reply-To: <CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com>
References: <20111104045817.GA25778@gamma.logic.tuwien.ac.at>
	<20111107123812.GB23508@gamma.logic.tuwien.ac.at>
	<1320709047.31823.188.camel@wwguy-huron>
	<20111108043233.GA21171@gamma.logic.tuwien.ac.at>
	<CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com>
	<CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com>
	<20111109051152.GA16006@gamma.logic.tuwien.ac.at>
	<CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com>
	<20111121030640.GI32505@gamma.logic.tuwien.ac.at>
	<CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com>
	<20111122051310.GA23705@gamma.logic.tuwien.ac.at>
	<CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com>
Date: Tue, 22 Nov 2011 08:48:19 +0200
Message-ID: <CANUX_P1RjcRD2tW1A6YYSEV9+aUZyTEro7tZXJWRoxk6gx-2jA@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 08:46, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Tue, Nov 22, 2011 at 07:13, Norbert Preining <preining@logic.at> wrote:
>> On Mo, 21 Nov 2011, Emmanuel Grumbach wrote:
>>> > If you think I shouuld turn on power debug again and see hope that
>>> > it happens again, let me know.
>>>
>>> No, I don't think it is needed. Thanks.
>>
>
> Hi Norbert,
>
> Please apply the patch attached. It has been submitted upstream but
> hasn't been merged in the tree you use apparently.
> Then please run with set the TXQUEUES debug flag: 0x8000000.
> This will give us a better understanding regarding what happens with
> the queues and how they are mapped.
> Do you use any SoftAP / P2P feature ? HW queues can be stalled
> sometimes when using such configuration. Can it also be that the AP
> that we can't work with has any kind of power save feature (I know
> that this one is hard to answer though :-)) ?
>
> Thanks !
>

Forgot to reply on the WARN_ON you saw. Yes I know about it. We seem
to have a race between mac80211 and the driver somewhere. I will look
at it when I will have time for that one. Hopefully before Armageddon.
