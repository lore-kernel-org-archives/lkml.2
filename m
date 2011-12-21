Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1LUQhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:37:23 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:47100 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752053Ab1LUQhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:37:19 -0500
Message-ID: <4EF20B3A.5040406@LiPPERTEmbedded.de>
Date: Wed, 21 Dec 2011 17:37:14 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org
Subject: Re: IRQF_TIMER | IRQF_SHARED ?
References: <4EE620A5.7080402@LiPPERTEmbedded.de>	<20111212123131.502be350@queued.net>	<4EE77416.8090907@LiPPERTEmbedded.de>	<4EE8ECF3.6000900@LiPPERTEmbedded.de> <20111214104724.292b02d4@queued.net>
In-Reply-To: <20111214104724.292b02d4@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Dec 2011 16:37:16.0603 (UTC) FILETIME=[CCD548B0:01CCBFFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

>> I found that SMP-enabled kernels (like the generic one I was
>> using) do load cs5535-clockevt fine but ignore it and keep using
>> the pit timer instead.

Solved, hope my patch is ok.

> I didn't know SMP CS5536 boards existed.

They don't. I was talking about SMP-capable kernels, e.g. _generic_ distro
kernels which were compiled with SMP support enabled, even though this feature
is not needed for a UP-only Geode. Sorry if I wasn't making myself clear.

Cheers,
Jens
