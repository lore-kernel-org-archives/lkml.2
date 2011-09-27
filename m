Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1I0RqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:46:08 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:50177 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1I0RqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:46:05 -0400
In-Reply-To: <20110902174812.GD6619@n2100.arm.linux.org.uk>
References: <20110823220056.GK3895@n2100.arm.linux.org.uk>	<20110825130907.GO3286@htj.dyndns.org>
	<20110825145558.GF8883@n2100.arm.linux.org.uk>	<201108261644.26329.arnd@arndb.de>
	<OF2C5ADB6A.65B1BE36-ONC12578FE.00493A67-C12578FE.004B3315@de.ibm.com>	<20110901140000.GF29729@n2100.arm.linux.org.uk>
	<OF69A57AB0.CF22689A-ONC12578FF.004EDD71-C12578FF.005142FF@de.ibm.com>	<20110902172259.GA6619@n2100.arm.linux.org.uk>
	<OFA88E54BC.55310B1A-ONC12578FF.00607E64-C12578FF.00611957@de.ibm.com> <20110902174812.GD6619@n2100.arm.linux.org.uk>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
X-KeepSent: 3526BDDC:47424131-C1257918:00614DE3;
 type=4; name=$KeepSent
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-toolchain@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <martin.schwidefsky@de.ibm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF3526BDDC.47424131-ONC1257918.00614DE3-C1257918.006195CC@de.ibm.com>
From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Date: Tue, 27 Sep 2011 19:45:53 +0200
X-MIMETrack: Serialize by Router on D12ML069/12/M/IBM(Release 8.0.2FP2|June 22, 2009) at
 27/09/2011 19:46:01
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> And yes, we can end up processing the interrupt before the SVC is
> executed, which is still a hole.  So we need to avoid doing the
> restart in userspace - which might actually make things easier.
> I'll take a look into that over the weekend.

Hi Russell, I was wondering whether is there any news on this?
If you do rewrite the signal handler processing, please let me
know so I can update GDB accordingly ...  Thanks!


Mit freundlichen Gruessen / Best Regards

Ulrich Weigand

--
  Dr. Ulrich Weigand | Phone: +49-7031/16-3727
  STSM, GNU compiler and toolchain for Linux on System z and Cell/B.E.
  IBM Deutschland Research & Development GmbH
  Vorsitzender des Aufsichtsrats: Martin Jetter | Geschäftsführung: Dirk
Wittkopp
  Sitz der Gesellschaft: Böblingen | Registergericht: Amtsgericht
Stuttgart, HRB 243294

