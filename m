Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab1EYPdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:33:10 -0400
Received: from mail.palosanto.com ([200.93.199.101]:59807 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757029Ab1EYPdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:33:08 -0400
Message-ID: <4DDD20C3.4080603@fiec.espol.edu.ec>
Date: Wed, 25 May 2011 10:31:15 -0500
From: =?UTF-8?B?QWxleCBWaWxsYWPDrcKtcyBMYXNzbw==?= 
	<avillaci@fiec.espol.edu.ec>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Subject: Re: [Bug #28522] Unable to mount FAT-formatted floppy on /dev/fd0,
 plus WARN_ON when using /dev/fd0u1440
References: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera> <SFkDk2sBn_E.A.ScE.STwzNB@chimera>
In-Reply-To: <SFkDk2sBn_E.A.ScE.STwzNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 14/05/11 17:40, Rafael J. Wysocki escribió:
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
> Date		: 2011-02-07 17:21 (97 days old)
>
>
>
Still present in 2.6.39. Additionally there is a new regression in bug #35832.
