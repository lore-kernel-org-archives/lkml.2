Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab2J3Jzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:55:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab2J3Jzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:55:53 -0400
Message-ID: <508FA405.2050509@redhat.com>
Date: Tue, 30 Oct 2012 10:55:17 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Tvrtko Ursulin <tvrtko@ursulin.net>, Milan Broz <gmazyland@gmail.com>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org, okozina@redhat.com,
        linux-rt-users@vger.kernel.org
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - RT patch set seem
 to break it
References: <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net> <508EDD6E.7030908@gmail.com> <508EE395.9010709@ursulin.net> <508EEAF2.4090506@ursulin.net> <20121030094001.GV639@pengutronix.de>
In-Reply-To: <20121030094001.GV639@pengutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 10:40 AM, Uwe Kleine-König wrote:
>> Ha, this is exciting, vanilla 3.6.4 works, with -rt10 patch it does not.
> I experienced that problem, too. This is on a laptop with encrypted
> rootfs, so debugging is a bit harder here. I am just setting up another
> machine to debug that.

FYI the problematic patch is peterz-srcu-crypto-chain.patch in rt10
patchset, after that, crypto_alloc_ablkcipher() now returns -ENOENT (-2)
in dmcrypt.

(I will check it later but maybe someone already playing with it...)

Milan

