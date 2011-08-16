Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1HPOdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:33:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab1HPOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:33:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Tue, 16 Aug 2011 16:32:21 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kenneth Heitke <kheitke@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <201108161537.28612.arnd@arndb.de> <20110816135051.GA22227@huya.qualcomm.com>
In-Reply-To: <20110816135051.GA22227@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161632.22255.arnd@arndb.de>
X-Provags-ID: V02:K0:9jgIC0H/jym/QUrN/K4I70oE5vzTqO6wll701feDa8C
 3Icq4p1drqgFKn+yydfmYEmUChMwcmJrYmfNUmJcvk7IfKbJVB
 mYRAo7a3kyit9d+GQDVmezTJ/eFyukS7XimdM/zCE1c/7jnnWf
 TsANPInf/Zhl0QxIJmWh6hEljqgj7lfyfbs8tjz/JfH0KmF4c7
 RRE77kWAnsxHF0K4y5qmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011, David Brown wrote:
> On Tue, Aug 16, 2011 at 03:37:28PM +0200, Arnd Bergmann wrote:

> > This is theoretically true, but IIRC David mentioned that the bus is
> > only present on few SoCs and has since been abandoned in favor of standard
> > busses for new devices.
> 
> Actually, this is a different one than the one I was mentioning at the
> Linaro Connect.  I believe SLIMbus is more active
> http://en.wikipedia.org/wiki/SLIMbus
> 
> The other bus I was mentioning is called SSBI, which as far as I know
> is only used to communicate between MSMs and certain Qualcomm
> peripheral chips.

Thanks for the clarification! I assumed these were the same thing because
the patches were posted just after we had talked about the other one.

> Kenneth would better be able to clarify how dynamic the SLIMbus is.

That would definitely be helpful. Also, I'd be very interested to hear
what kind of device probing is available on slimbus. If Mark was
right about devices being discoverable, we need don't need any board
description (dts or hardcoded) but instead a way to match the devices
to drivers based on their HW ID.

	Arnd
