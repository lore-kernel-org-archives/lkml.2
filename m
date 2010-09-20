Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0ITLtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 07:49:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44155 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab0ITLtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 07:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=QC7mtn+zVXNIEyRMKbfipHSTBMc4dW1MQZ0BKJ/zojnMYc9jFY+T5iE9ZKEa/Kd8qE
         kLPLI8VdPT+w3DI07K57NrpNYGBt/g+oJJ2Fi6OZA17aPO0HrvbOICXO17FXEU5rRPK+
         c2YP06ct9i1W+wuf3/g4590b9M8MHWKUfkCdY=
MIME-Version: 1.0
Date: Mon, 20 Sep 2010 12:49:38 +0100
Message-ID: <AANLkTimigBxKWaJ6LNxu6a0uXo8+LOfzcoE8bVsXZ1bW@mail.gmail.com>
Subject: [x86] x86 targets without CMOS still build rtc.c despite CONFIG_RTC unset
From: Andy Clark <andy.apcs@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I haven't taken the time to fully understand the build mechanism, but
comparing the x86 with other targets, the x86 target doesn't appear to
support CONFIG_RTC.  Leaving this unset doesn't prevent
arch/x86/kernel/rtc.c being built into the kernel.

I'm building a linux-2.6.32.16 kernel using OpenWRT trunk for
Bifferboard, an rdc target.  The Bifferboard SOC does not have an RTC.

Is this as-designed (i.e. do "all" rdc targets have RTC) or a work-in-progress?

Thanks,

Andy.
