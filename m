Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2DGPNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 11:13:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65199 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab2DGPNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 11:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <CABe5r8KL=c1=emU_20ODwM5OvFJS9vaKV1ux2hSmGB5tmZoJ1w@mail.gmail.com>
References: <1333795467-3643-1-git-send-email-eldad@fogrefinery.com>
	<20120407.084657.1719148601003380853.davem@davemloft.net>
	<CABe5r8KL=c1=emU_20ODwM5OvFJS9vaKV1ux2hSmGB5tmZoJ1w@mail.gmail.com>
Date: Sat, 7 Apr 2012 17:13:45 +0200
Message-ID: <CABe5r8Kygjg0O21Y5z-F=RRQCqT7ReNya+EohAJU1jauaK536Q@mail.gmail.com>
Subject: Re: [PATCH] net/ipv6/exthdrs.c et al: Optional strict PadN option checking
From: Eldad Zack <eldad@fogrefinery.com>
To: David Miller <davem@davemloft.net>
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend, previous message was [rightfully] rejected by the mailer)

On 7 April 2012 17:09, Eldad Zack <eldad@fogrefinery.com> wrote:
>
> On 7 April 2012 14:46, David Miller <davem@davemloft.net> wrote:
>>
>> From: Eldad Zack <eldad@fogrefinery.com>
>> Date: Sat,  7 Apr 2012 12:44:27 +0200
>>
>> > Added strict checking of PadN, which can be used to increase header
>> > size and thus push the protocol header into the 2nd fragment.
>>
>> A sysctl _AND_ a kconfig option, give me a break, that's
>> pointless.
>>
>> Either we want this or we don't.
>
>
> You're right, that kconfig bit was silly.
> I'd like to keep the sysctl knob, though.
>
> Fixed patch follows.
>
> Eldad
