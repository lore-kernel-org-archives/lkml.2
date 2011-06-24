Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1FXHDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 03:03:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54767 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab1FXHDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 03:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikFFUREhKyPaZrhHZje0KeaA3ef8Q@mail.gmail.com>
References: <1308862894-13802-1-git-send-email-jaswinder.singh@linaro.org>
	<BANLkTikFFUREhKyPaZrhHZje0KeaA3ef8Q@mail.gmail.com>
Date: Fri, 24 Jun 2011 12:33:09 +0530
Message-ID: <BANLkTikODvHRWa6HHaWZr2Gy0SjBbn2J-w@mail.gmail.com>
Subject: Re: [PATCH] mfd: omap: Restore TLL initialization
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        ti@lists.linaro.org, parthab@india.ti.com, sameo@linux.intel.com,
        gadiyar@ti.com, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2011 11:52, Munegowda, Keshava <keshava_mgowda@ti.com> wrote:
> On Fri, Jun 24, 2011 at 2:31 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>> The commit
>>  7e6502d577106fb5b202bbaac64c5f1b065 'mfd: Add omap-usbhs runtime PM support'
>> besides moving to RPM, removes necessary TLL initialization as well.
>>
>> Restore the TLL initialization, without which device detection fails.
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>
> if you move to RPM, you should'tn access these configuration/reset
> registers in your driver.
Sorry I don't get it.  Obviously the RPM backend here doesn't initialize
the TLL and if it only manages the clocks, can't we safely assume that
the pm_runtime_get_sync will get clocks to speed and the driver does
the TLL init ?

> moreover, the patch 'mfd: Add omap-usbhs runtime PM support' is
> already reverted.
Ok, though if the ultimate goal is to move on to RPM, this would be a
step back.
Btw, which tree could I find the revert in ?

Thanks,
Jassi
