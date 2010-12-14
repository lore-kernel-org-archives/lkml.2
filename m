Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab0LNSRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:17:24 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:57702 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758211Ab0LNSRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:17:23 -0500
MIME-Version: 1.0
In-Reply-To: <20101214180840.GB4584@pengutronix.de>
References: <1290205185-11956-1-git-send-email-bengardiner@nanometrics.ca>
	<cover.1291925752.git.bengardiner@nanometrics.ca>
	<67270e44ec792d1a684d6052f7aebbc8c538a6c1.1291925752.git.bengardiner@nanometrics.ca>
	<20101210114604.GB4228@pengutronix.de>
	<AANLkTimdw5crEJTdnObURp_kxqjwFas2RuDMewd=CqEG@mail.gmail.com>
	<20101214180840.GB4584@pengutronix.de>
Date: Tue, 14 Dec 2010 13:17:22 -0500
Message-ID: <AANLkTi=Fi+TaV=FJfz07kGBLnKMDoh5ph2vnLA9xLNVK@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 2/3] spi_bitbang : get nsecs delay from cs during transfer
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 1:08 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi Ben,
>
>> I think it is starting to sink-in that a 'slower' spi gpio _driver_ is
>> needed. I can think of a couple different ways to make the CS-to-data
>> delay assigned to 'nsecs' a per-device feature:
>> 1) a flag or 2) a function pointer in struct spi_bitbang. Were you
>> thinking of something else entirely?
>
> Nope, just saw (very high-level) that it should be per-device as it
> might be feasible to have a fast and a slow bus at the same time. My
> advice would be to start coding your favourite solution and check if it
> feels right :)

:) Sounds like good advice.

Thanks again, Wolfram.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
