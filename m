Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1FUWfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:35:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54746 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab1FUWfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:35:07 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinJOf+L1kE9gQ99=uA_HK2_+Hts-AyAD8QuWNAa-rZ9+Q@mail.gmail.com>
References: <20110621002318.8086.48367.stgit@riker> <BANLkTi=aaSnT-incv3FhOZ0Yp8CtYf31mA@mail.gmail.com>
 <BANLkTinJOf+L1kE9gQ99=uA_HK2_+Hts-AyAD8QuWNAa-rZ9+Q@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 21 Jun 2011 16:34:46 -0600
X-Google-Sender-Auth: EDMO2lx4simoJLcaZf5TtBZzci0
Message-ID: <BANLkTi=S8ddKE_ahHXDhW75hhPohqS+gRQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: Tegra: i2c driver
To: Olof Johansson <olof@lixom.net>
Cc: John Bonesio <bones@secretlab.ca>, kradtke@nvidia.com, swarren@nvidia.com,
        lucas.demarchi@profusion.mobi, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, riyer@nvidia.com,
        linux-i2c@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        Olof Johansson <olofj@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 4:11 PM, Olof Johansson <olof@lixom.net> wrote:
> On Mon, Jun 20, 2011 at 9:59 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Mon, Jun 20, 2011 at 6:23 PM, John Bonesio <bones@secretlab.ca> wrote:
>>> This patch modifies the tegra i2c driver so that it can be initiailized
>>> using the device tree along with the devices connected to the i2c bus.
>>>
>>> Signed-off-by: John Bonesio <bones@secretlab.ca>
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
> Acked-by: OIof Johansson <olof@lixom.net>
>
>
> (with the same suggestion to change subject as Stephen/Grant discussed
> later in the thread).

Ben, would you like a new patch with the new subject line, or will you
fix it up when you merge it?

g.
