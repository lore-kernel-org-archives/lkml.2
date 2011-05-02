Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1EBVEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:04:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54632 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab1EBVEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:04:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ulpOW4rgbRQocXVC3Yl2f/QiCJFuIFxyhLY167O6g3KjxbIFq0XHatXfcUuv06nHdu
         2o07MDOHAMGIxFlSs6FzWPPlwVI4lj6yrTOkEwc1YvfY9zPU2VnbjJ2EDh3BkTLx1MKT
         W6HoVC3Ba1aGNxRFldHGJ8izjGdUkYFk7yFV4=
MIME-Version: 1.0
In-Reply-To: <G9uL1cldhmL.A.caE.nVGvNB@chimera>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera> <G9uL1cldhmL.A.caE.nVGvNB@chimera>
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Mon, 2 May 2011 23:04:21 +0200
Message-ID: <BANLkTimiSXHSxsjPH03Yey555U+F4m1uOA@mail.gmail.com>
Subject: Re: [Bug #33482] [Regression] Bluetooth pairing does not work anymore
 in 2.6.39-rc3 (works in 2.6.38.3)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=33482
> Subject         : [Regression] Bluetooth pairing does not work anymore in 2.6.39-rc3 (works in 2.6.38.3)
> Submitter       : Gottfried Haider <gottfried.haider@gmail.com>
> Date            : 2011-04-16 16:38 (15 days old)
> Message-ID      : <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=130297197128328&w=2

This can be removed from the regression list as it turned out to be
only a mis-config-uration (oldconfig listed BT_L2CAP as a new config
option, defaulting to false, when it had been build as a module
before).

regards,

Gottfried
