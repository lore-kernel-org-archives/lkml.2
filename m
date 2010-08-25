Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab0HYDCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 23:02:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58116 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab0HYDCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 23:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vdC+W6audtJ+LQKIxWXQaaCtr78lElrNgyf9ihiucetJVAhvKNIkIZBMxNcXsjFBFX
         gpAOCEtgbPrgpq9dhDDVrlGXar99ngdeaPxqP7/0oQeX6vTfKtJ1hsSzC8B2LYduBrhz
         PVoWDklS4FQyFX7j81/zeX0S4j3V0n4diFDYs=
MIME-Version: 1.0
In-Reply-To: <201008241936.18681.thomas@m3y3r.de>
References: <201008011101.01429.thomas@m3y3r.de>
	<20100801151409.252be86b@tux.DEF.witbe.net>
	<4C559022.1010406@gmail.com>
	<201008241936.18681.thomas@m3y3r.de>
Date: Wed, 25 Aug 2010 05:02:13 +0200
Message-ID: <AANLkTingXK2Yk-880zLAvMr7bE0PVvnDy3=oqRYKuqtU@mail.gmail.com>
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
From: Roberto Oppedisano <roberto.oppedisano@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Paul Rolland <rol@as2917.net>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zou Nan hai <nanhai.zou@intel.com>,
        Xiang Hai hao <haihao.xiang@intel.com>, Eric Anholt <eric@anholt.net>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/24, Thomas Meyer <thomas@m3y3r.de>:
> On Sunday 01 August 2010 17:17:54 Roberto Oppedisano wrote:
>>   On 01/08/2010 15:14, Paul Rolland wrote:
>> > My machine has :
>> > 00:02.0 0300: 8086:2a42 (rev 07)
>> > 00:02.1 0380: 8086:2a43 (rev 07)
>> >
>> > 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
>> > Chipset Integrated Graphics Controller (rev 07)
>> > 00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
>> > Integrated Graphics Controller (rev 07)
>> >
>> > (Dell Vostro 1520, BIOS Revision A04)
>> >
>> >>>   Is it suspend
>> >>> or resume that is unreliable?
>> >> suspend never finishes/hangs.
>
> Seems to be fixed in 2.6.36-rc2. Probably by merge commit
> 4238a417a91643e1162a98770288f630e37f0484.
>
> Paul, Roberto: Could you please confirm this on your hardware?

The problem seems fixed for me too.
