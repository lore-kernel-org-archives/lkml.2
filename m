Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab1LOD7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:59:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50465 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab1LOD7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:59:04 -0500
Date: Thu, 15 Dec 2011 09:28:54 +0530
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/19] eukrea-cpuimx51: remove board
Message-ID: <20111215035854.GA24039@avalanche>
Mail-Followup-To: Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>,
	open list <linux-kernel@vger.kernel.org>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
 <1323757911-25217-16-git-send-email-eric@eukrea.com>
 <20111213100532.GH27267@pengutronix.de>
 <4EE7253E.2030604@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EE7253E.2030604@eukrea.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Dec 13, Eric Bénard wrote:
> Hi Sascha,
> 
> Le 13/12/2011 11:05, Sascha Hauer a écrit :
> >On Tue, Dec 13, 2011 at 07:31:48AM +0100, Eric Bénard wrote:
> >>this board is not maintained anymore and is replaced by cpuimx51sd
> >
> >I'm happy to remove this code, but aren't there any users of this board?
> >
> not any that would need a kernel upgrade considering the Freescale
> proprietary drivers used on it :-(
> Thanks,
> Eric

Just for posterity, could you list the drivers that make an upgrade
impossible?

IMHO, if these boards were sold commercially we should maintain support if
there is a chance that we will get open drivers in the future.

OTOH, if you can tell who each of these boards to, it is probably a good
target for removal. :)

/Amit

-- 
--------------------------------------------------------------------------------
Amit Kucheria, Power Management Tech Lead, Linaro || amit.kucheria@canonical.com
--------------------------------------------------------------------------------
