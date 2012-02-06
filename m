Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2BFUsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:48:33 -0500
Received: from imr4.ericy.com ([198.24.6.9]:46415 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab2BFUsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:48:32 -0500
Message-ID: <1328561164.2261.258.camel@groeck-laptop>
Subject: Re: [PATCH v5 4/5] hwmon: add MAX197 support
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Date: Mon, 6 Feb 2012 12:46:04 -0800
In-Reply-To: <20120206151507.73a23eb8@v0nbox>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <1328130344-18836-5-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <1328132138.2261.116.camel@groeck-laptop> <20120206151507.73a23eb8@v0nbox>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivien,

On Mon, 2012-02-06 at 15:15 -0500, Vivien Didelot wrote:
[ ... ]
> 
> BTW, about the TS-5500 ADC part, is a platform ts5500_adc.c file the
> better solution, or should the device be declared in the ts5500.c
> platform code?
> 
I would suggest to declare it in the ts5500.c platform code. That seems
to be the common approach as far as I can see.

platform_add_devices() works pretty well for this. It saves you from
having to call platform_device_register() for each device separately.
Obviously that only works if all devices are declared in a single file.

Thanks,
Guenter


