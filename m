Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0GLXFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:05:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31977 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0GLXFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:05:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6041"; a="47264353"
From: David Brown <davidb@codeaurora.org>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: ARM defconfig files
Date: Mon, 12 Jul 2010 16:05:32 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.1; KDE/4.4.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com> <20100712185029.GB14425@pengutronix.de>
In-Reply-To: <20100712185029.GB14425@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007121605.32462.davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 July 2010 11:50:29 Uwe Kleine-König wrote:

> If it helps the powerpc people I can reduce their defconfigs, too.

Do you have scripts or tools that you did this with, or is a manual
process.  We're about to add several new (ARM) targets, and it'd be
nice to be able to make small defconfigs for those targets as well.

Thanks,
David
