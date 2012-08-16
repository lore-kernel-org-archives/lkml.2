Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2HPMpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:45:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44912 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab2HPMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:45:51 -0400
Date: Thu, 16 Aug 2012 13:45:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V3 1/8] DA9058 MFD core driver
Message-ID: <20120816124547.GJ15365@opensource.wolfsonmicro.com>
References: <201208151518.q7FFIN9v011639@latitude.olech.com>
 <20120815185316.GG15365@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032C6702@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032C6702@NB-EX-MBX02.diasemi.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:34:56AM +0000, Opensource [Anthony Olech] wrote:

Fix your mail configuration to word wrap at something less than 80
columns within paragraphs, your mails are currently extremely hard to
read.

> The only other interpretation of your comment is that the h/w IRQ line setup code must be done
> in the machine driver, in my case for testing is arch/arm/mach-s3c64xx/mach-smdk6410.c
> But that view is contricted by the init call-backs from the wm8350 and wm1192 drivers.

This board driver is not a modern driver, configuration callbacks used
to be used but this is no longer be something that's needed.

> I am confused, but it does make sense to do the GPIO --> IRQ initialization in the machine driver,
> so I will try to do that. But who would be responsible for changing the wm8350 and wm1192 drivers
> to also follow that philosophy?

If someone has the time and enthusiasm it might be worthwhile, but it's
not clear that this is the case.
