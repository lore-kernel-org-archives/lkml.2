Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab1H3A3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 20:29:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39466 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1H3A3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 20:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MWx9Z+2dWP4OjVO+1T+3EsAE0geZhdRM2_B9osKw-Mw2A@mail.gmail.com>
References: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
	<CACqU3MWx9Z+2dWP4OjVO+1T+3EsAE0geZhdRM2_B9osKw-Mw2A@mail.gmail.com>
Date: Mon, 29 Aug 2011 20:29:01 -0400
Message-ID: <CACqU3MXJafAX4Wee8goNtrKF3L1JPCz7xPaQwcQ6nynX60Rrow@mail.gmail.com>
Subject: Re: [PATCH 0/4] Kbuild/Kconfig
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 22, 2011 at 11:49 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Tue, Aug 16, 2011 at 1:34 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Hi Michal,
>>
>> The following small serie unexpose a few Kconfig variable from Kbuild, and
>> vice-versa. The idea is that Kbuild is a user of Kconfig, not the other way
>> around.
>>
>> In the same time, fix a couple of place where we hardcode the `.config' string.
>>
>> Comments Welcome !
>>  - Arnaud
>>
> ping ?
>
ping^2 ?

 - Arnaud

>  - Arnaud
>
>> Arnaud Lacombe (4):
>>  kbuild: introduce KBUILD_CONFIG; unexpose KCONFIG_CONFIG
>>  kbuild: reduce kbuild invasivity within kconfig
>>  kbuild: do not hardcode .config
>>  kconfig: do not hardcode .config
>>
>>  Makefile                                |   20 ++++++++++++++------
>>  arch/arm/boot/compressed/Makefile       |    2 +-
>>  arch/unicore32/boot/compressed/Makefile |    2 +-
>>  scripts/kconfig/Makefile                |   31 ++++++++++++++++---------------
>>  4 files changed, 32 insertions(+), 23 deletions(-)
>>
>> --
>> 1.7.6.153.g78432
>>
>>
>
