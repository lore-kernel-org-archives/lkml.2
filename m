Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab1DMI7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:59:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab1DMI7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:59:36 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Gabriel Paubert <paubert@iram.es>, Greg KH <greg@kroah.com>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>
Subject: Re: small git lesson [Was: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?]
References: <20110404235259.GA30132@iram.es>
	<20110406084101.GB13963@pengutronix.de>
	<BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
	<20110406204327.GA11148@iram.es>
	<1302185075.24704.143.camel@thor.local>
	<20110411133128.GA24344@iram.es>
	<1302535963.24704.268.camel@thor.local>
	<20110412113033.GA16649@iram.es>
	<1302608770.27054.36.camel@thor.local> <20110413080204.GA3871@iram.es>
	<20110413081246.GK18850__3180.67204575545$1302682420$gmane$org@pengutronix.de>
X-Yow: "THE LITTLE PINK FLESH SISTERS," I saw them at th' FLUORESCENT BULB
 MAKERS CONVENTION...
Date: Wed, 13 Apr 2011 10:59:14 +0200
In-Reply-To: <20110413081246.GK18850__3180.67204575545$1302682420$gmane$org@pengutronix.de>
	("Uwe =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Wed, 13 Apr 2011
 10:12:46 +0200")
Message-ID: <m339lm8r31.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:

> $ git name-rev --refs=refs/tags/v2.6\* 69a07f0b117a40fcc1a479358d8e1f41793617f2
> 69a07f0b117a40fcc1a479358d8e1f41793617f2 tags/v2.6.39-rc2~3^2~43^2~4
>
> so it was introduced just before -rc2.

$ git tag --contains 69a07f0b117a40fcc1a479358d8e1f41793617f2
v2.6.39-rc1
v2.6.39-rc2

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
