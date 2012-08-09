Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2HIGlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:41:40 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:49462
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135Ab2HIGlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:41:39 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q796fMhw010579
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Rob Landley <rob@landley.net>, Milton Miller <miltonm@bga.com>,
        Borislav Petkov <bp@alien8.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jan Engelhardt <jengelh@inai.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening port
In-Reply-To: <50228781.7040502@gmail.com> (Cong Wang's message of "Wed, 08 Aug
	2012 23:36:33 +0800")
References: <gilii4nnxb.fsf@mx10.gouders.net> <kernel-nc-hints@mdm.bga.com>
	<501937F7.2070600@landley.net> <gi3946lin5.fsf@mx10.gouders.net>
	<gisjc5hvun.fsf@mx10.gouders.net>
	<CAM_iQpWoKGJTUjohn9_guktpBNbOazKY1_eUQozz_O6ZkRmyPg@mail.gmail.com>
	<giobmsiixa.fsf@mx10.gouders.net> <50228781.7040502@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 09 Aug 2012 08:41:19 +0200
Message-ID: <gi4noc36uo.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 09 Aug 2012 08:41:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On 08/03/2012 02:33 PM, Dirk Gouders wrote:
>>
>>  From b3aec70d785d338b1b643fece6606cd32addaf0c Mon Sep 17 00:00:00 2001
>> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
>> Date: Thu, 2 Aug 2012 22:20:16 +0200
>> Subject: [PATCH] netconsole.txt: revision of examples for the receiver of kernel messages
>>
>> There are at least 4 implementations of netcat with the BSD-based
>> being the only one that has to be used without the -p switch to
>> specify the listening port.
>>
>> Jan Engelhardt suggested to add an example for socat(1).
>>
>> Signed-off-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
>
> It looks like no one takes this patch, so I will take it together with
> my other netpoll/netconsole patches and send them to netdev.

Thank you for taking care of it.

Dirk

