Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1DARmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:42:15 -0400
Received: from mail.palosanto.com ([200.93.199.101]:54242 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393Ab1DARmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:42:14 -0400
Message-ID: <4D960E2F.1050408@fiec.espol.edu.ec>
Date: Fri, 01 Apr 2011 12:41:03 -0500
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
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera> <40UNry85rJN.A.CKF.Kp5jNB@chimera>
In-Reply-To: <40UNry85rJN.A.CKF.Kp5jNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 27/03/11 15:27, Rafael J. Wysocki escribió:
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
> Date		: 2011-02-07 17:21 (49 days old)
>
>
>
Just checked yesterday. This bug is still present in 2.6.39-rc1.
