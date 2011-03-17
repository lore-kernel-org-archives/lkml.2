Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1CQPWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:22:14 -0400
Received: from mail.palosanto.com ([200.93.199.101]:37925 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754165Ab1CQPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:22:11 -0400
X-Greylist: delayed 1469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 11:22:10 EDT
Message-ID: <4D822129.1030000@fiec.espol.edu.ec>
Date: Thu, 17 Mar 2011 09:56:41 -0500
From: =?UTF-8?B?QWxleCBWaWxsYWPDrcKtcyBMYXNzbw==?= 
	<avillaci@fiec.espol.edu.ec>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Subject: Re: [Bug #28522] Unable to mount FAT-formatted floppy on /dev/fd0,
 plus WARN_ON when using /dev/fd0u1440
References: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera> <GTlFTeOGjrB.A.hEF.Or3cNB@chimera>
In-Reply-To: <GTlFTeOGjrB.A.hEF.Or3cNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 06/03/11 07:10, Rafael J. Wysocki escribió:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
> Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
> Submitter	: Alex Villacis Lasso<avillaci@ceibo.fiec.espol.edu.ec>
> Date		: 2011-02-07 17:21 (28 days old)
>
>
>
Still present in 2.6.38 .
