Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1DTUU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:20:58 -0400
Received: from mail.palosanto.com ([200.93.199.101]:32827 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752408Ab1DTUU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:20:56 -0400
Message-ID: <4DAF3FCB.2070407@fiec.espol.edu.ec>
Date: Wed, 20 Apr 2011 15:19:23 -0500
From: =?UTF-8?B?QWxleCBWaWxsYWPDrcKtcyBMYXNzbw==?= 
	<avillaci@fiec.espol.edu.ec>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Subject: Re: [Bug #28522] Unable to mount FAT-formatted floppy on /dev/fd0,
 plus WARN_ON when using /dev/fd0u1440
References: <sam8u5dLkaB.A.afE.53uqNB@chimera> <IqJL5EkbqD.A.KLG.Z6uqNB@chimera>
In-Reply-To: <IqJL5EkbqD.A.KLG.Z6uqNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 17/04/11 08:52, Rafael J. Wysocki escribió:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.37 and 2.6.38.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
> Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
> Submitter	: Alex Villacis Lasso<avillaci@ceibo.fiec.espol.edu.ec>
> Date		: 2011-02-07 17:21 (70 days old)
>
>
>
Still present in 2.6.39-rc4.
