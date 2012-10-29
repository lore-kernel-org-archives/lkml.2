Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab2J2Rly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:41:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51450 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab2J2Rlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:41:51 -0400
MIME-Version: 1.0
In-Reply-To: <508E95B3.7070807@antcom.de>
References: <CAAAP30E-g3YdXOMvfueDQZREZ+_Adi2uhxgLeqKixkupU+QNhA@mail.gmail.com>
	<508E7B47.60207@antcom.de>
	<CAAAP30HWhz_h4AVwjkw9APw6pv0ydO=GZ89uaBhKbmjw60ym4Q@mail.gmail.com>
	<508E95B3.7070807@antcom.de>
Date: Mon, 29 Oct 2012 15:41:50 -0200
Message-ID: <CAAAP30HRRnZQVhJAP19HZ_nJtn6GPeWZeEsst2pyhYZ5JM=Eow@mail.gmail.com>
Subject: Re: 3.7-rc3 oops on reboot
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 12:41 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 10/29/2012 02:51 PM, Alexandre Pereira da Silva wrote:
>>> I just tried both on a PHY3250 reference machine, and on a custom board
>>> and couldn't reproduce sth. like this. Booted the kernel and connected
>>> the ethernet cable later on, as well as with cable connected on boot.
>>
>> This is happening on my custom board. I didn't try this on the
>> reference board yet.
>>
>>> Any related patches applied? Can you reproduce this on a reference
>>> machine? Can you provide a .config for this? Any more detail about how
>>> this could be reproduced?
>>
>> No patches applied. I'm trying to bisect this. This happens on a clean
>> -rc1 as well. Doesn't happen on v3.6.
>>
>> Attached my .config
>>
>> To reproduce this, I am just running "reboot". I have the ethernet
>> cable always connected here.
>
> Just tried this with your .config on the PHY3250 (w/o your initrd
> thought) but couldn't reproduce the issue.
>
> Maybe it's related to your Micrel ethernet PHY (activated in your
> config) which I don't have hardware for?
>
> Otherwise, we would need to have a look at your devicetree.

Thanks for testing. I will investigate this further to see if I can
narrow source of the problem.
