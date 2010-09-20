Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0ITTUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:20:04 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42130 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab0ITTT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=pDnY1/Yytt5hLmEZ6aa2jBXabNEW6ss1oEL/fDNnUXLjL64iHL5IAuv/x2pClfDvv4
         vqypJ4svv+esJWbw6j+y+FRYnUrpW9Ue73lmLU5pgELkkvHNZjJ0uUeh2JkMlJim7gML
         uCljAxHKSOgkGSc5WjFCHLICnR2/UGYoe1+eA=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1fwtoy8sG5H.A.veG.9D7lMB@chimera>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera>
Date: Mon, 20 Sep 2010 21:19:58 +0200
Message-ID: <AANLkTinLR0Js0ueVOGEkbs27d4FEH14c=1wuhUqPsiHx@mail.gmail.com>
Subject: Re: 2.6.36-rc4-git5: Reported regressions from 2.6.35
From: Sedat Dilek <sedat.dilek@googlemail.com>
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
        DRI <dri-devel@lists.freedesktop.org>, harn-solo@gmx.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

can you please add the following, Thanks in advance.
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=18872
> Subject         : Radeon KMS r100 and STR problems
> Submitter       : Richard Mittendorfer <delist@gmx.net>
> Date            : 2010-09-17 18:26 (4 days old)
> Message-ID      : <20100917202647.aa4b6300.delist@gmx.net>
> References      : http://marc.info/?l=linux-kernel&m=128474802809779&w=2

On Mon, Sep 20, 2010 at 8:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.35,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
>
> If you know of any other unresolved regressions from 2.6.35, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply
> to this message with CCs to the people involved in reporting and handling
> the issue.
>
>
> Listed regressions statistics:
>
>  Date          Total  Pending  Unresolved
>  ----------------------------------------
>  2010-09-20       38       15          15
>  2010-09-12       28       14          13
>  2010-08-30       21       16          15
>
>
> Unresolved regressions

Hi Rafael,

can you please add the following Bug, Thanks in advance.

Bug-Entry       : https://bugzilla.kernel.org/show_bug.cgi?id=16140
Subject         : Suspend To RAM/ Resume broken - Radeon KMS on RV250
Submitter       : Michael Long <harn-solo@gmx.de>
Date            : 2010-06-06 09:52
Message-ID      : ???
References      : ???

What is with "Regression:	No" in the BR? Change?

Regards,
- Sedat -
