Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab0JDSBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:01:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42710 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0JDSBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QJ0KWDkmPPRtQi26BcQ8dlbodvV6Z8BiRYm2GVkiWGKQlUJISamjOpB2KYX57MXl/9
         hgLxiXYRtHnRQw400j5z76WQx1aRM6uFkc5bnXPAFTHfFiiHPa7HvCxoxg4gXHmI6UPl
         gmJ7thLxAQEQXFN2sZzJZyYCsdMBcnsFD+V1w=
MIME-Version: 1.0
In-Reply-To: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
Date: Mon, 4 Oct 2010 20:01:00 +0200
Message-ID: <AANLkTi=ZwaH6ZL1g4d1jhfSXtQJGMGu-=YN+vTm+=UgS@mail.gmail.com>
Subject: Re: 2.6.36-rc6-git2: Reported regressions 2.6.34 -> 2.6.35
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/3 Rafael J. Wysocki <rjw@sisk.pl>:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=19302
> Subject         : PROBLEM: kernel crash on USB-modem (Huawei E1750) hangup.
> Submitter       : O01eg <O01eg@yandex.ru>
> Date            : 2010-09-26 19:50 (8 days old)
> Message-ID      : <op.vjnn1up1yohvy1@localhost>
> References      : http://marc.info/?l=linux-kernel&m=128553111709569&w=2

Comment from bugzilla:
> I got this bug at 2.6.34-gentoo-r6 and 2.6.36-rc5. Other kernels were not
> checked.

Doesn't sound like regression.

-- 
Rafał
