Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1FUWLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:11:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41066 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab1FUWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:11:52 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <BANLkTi=aaSnT-incv3FhOZ0Yp8CtYf31mA@mail.gmail.com>
References: <20110621002318.8086.48367.stgit@riker>
	<BANLkTi=aaSnT-incv3FhOZ0Yp8CtYf31mA@mail.gmail.com>
Date: Tue, 21 Jun 2011 15:11:50 -0700
Message-ID: <BANLkTinJOf+L1kE9gQ99=uA_HK2_+Hts-AyAD8QuWNAa-rZ9+Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: Tegra: i2c driver
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: John Bonesio <bones@secretlab.ca>, kradtke@nvidia.com, swarren@nvidia.com,
        lucas.demarchi@profusion.mobi, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, riyer@nvidia.com,
        linux-i2c@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        Olof Johansson <olofj@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 9:59 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Jun 20, 2011 at 6:23 PM, John Bonesio <bones@secretlab.ca> wrote:
>> This patch modifies the tegra i2c driver so that it can be initiailized
>> using the device tree along with the devices connected to the i2c bus.
>>
>> Signed-off-by: John Bonesio <bones@secretlab.ca>
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: OIof Johansson <olof@lixom.net>


(with the same suggestion to change subject as Stephen/Grant discussed
later in the thread).


-Olof
