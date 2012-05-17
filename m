Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965931Ab2EQVlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:41:10 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:57396 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760685Ab2EQVlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:41:08 -0400
Message-ID: <1337290826.7033.10.camel@trivette.site>
Subject: Re: [PATCH v6 3/3] gpio: TS-5500 GPIO support
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: x86@kernel.org, Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Thu, 17 May 2012 17:40:26 -0400
In-Reply-To: <20120517210633.400633E0621@localhost>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <1334276935-11258-4-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <20120517210633.400633E0621@localhost>
Organization: Savoir-faire Linux Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 15:06 -0600, Grant Likely wrote:
> >  arch/x86/include/asm/ts5500.h |   62 ++++++++
> 
> Why the separate header file?  What will use these defines?  I
> normally expect driver-specific defines to be in the driver .c file
> directly; particularly for things like gpio drivers which should be a
> generic interface that doesn't need to export symbols. 

Should an intermediate driver directly use values for GPIOs instead of
these symbols? For example, how should a temperature sensor plugged on
this platform refer to inputs and outputs?

Thanks,
	Vivien

