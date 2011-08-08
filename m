Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1HHOvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:51:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36362 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab1HHOvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:51:16 -0400
MIME-Version: 1.0
X-Originating-IP: [81.235.222.155]
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049F172168@HQMAIL01.nvidia.com>
References: <1312582534-10871-1-git-send-email-swarren@nvidia.com>
	<1312582534-10871-2-git-send-email-swarren@nvidia.com>
	<20110806174519.GB31966@ponder.secretlab.ca>
	<74CDBE0F657A3D45AFBB94109FB122FF049F172168@HQMAIL01.nvidia.com>
Date: Mon, 8 Aug 2011 07:51:14 -0700
Message-ID: <CAOesGMi2CXyAoy56-SdaD5YFzXW6W4wP6mnH+bVvRR3i_Mhk2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm/tegra: Delete irq_to_gpio
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 7:26 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Grant Likely wrote at Saturday, August 06, 2011 11:45 AM:
>> On Fri, Aug 05, 2011 at 04:15:34PM -0600, Stephen Warren wrote:
>> > irq_to_gpio is deprecated and in the process of being removed. Make that
>> > happen now for ARM Tegra.
>> >
>> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>
>> Applied both.  Thanks.
>
> Didn't you want an Ack by a Tegra maintainer first?

Acked-by: Olof Johansson <olof@lixom.net>

But either way is OK. No need to rebase to add an acked-by, as far as
I am concerned.


-Olof
