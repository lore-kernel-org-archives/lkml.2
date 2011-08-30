Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1H3FiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:38:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47353 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1H3FiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:38:05 -0400
Message-ID: <4E5C76E0.4000008@zytor.com>
Date: Mon, 29 Aug 2011 22:36:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, x86@kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com> <20110829221132.GB26846@sirena.org.uk>
In-Reply-To: <20110829221132.GB26846@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 03:11 PM, Mark Brown wrote:
> On Fri, Aug 26, 2011 at 07:40:25PM -0400, Vivien Didelot wrote:
> 
>>  arch/x86/platform/ts5500/ts5500_gpio.c |  421 ++++++++++++++++++++++++++++++++
>>  arch/x86/platform/ts5500/ts5500_gpio.h |   60 +++++
> 
> New GPIO drivers should really go under drivers/gpiolib and be called
> gpio-foo.c.
> 

Should they?  It seems a lot more reasonable to have them collected by
platform than by type of device (GPIO), *unless* they are shared.

	-hpa
