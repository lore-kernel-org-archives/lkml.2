Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2EATBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:01:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53450 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2EATBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:01:02 -0400
Message-ID: <4FA032EA.1090608@gmail.com>
Date: Tue, 01 May 2012 22:00:58 +0300
From: Adrian Fita <adrian.fita@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Ralf Jung <ralfjung-e@gmx.de>, Paolo Scarabelli <paolo@msw.it>
Subject: Re: [bug?] Battery notifications produce flashing battery icon, syslog
 spam (Re: [PATCH 11/11] ACPI / Battery: Update information on info notification
 and resume)
References: <201101062331.17079.rjw@sisk.pl> <201101062342.28168.rjw@sisk.pl> <20120501184534.GA31731@burratino>
In-Reply-To: <20120501184534.GA31731@burratino>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/12 21:47, Jonathan Nieder wrote:
 >
> [...]
 >
> [...]  More background
> at [2].
>
> [2] http://bugs.debian.org/670958

Also, searching on Google after "upowerd device 
removed:/org/freedesktop/UPower/devices/battery_BAT0", reveals much more 
bug reports with the exact issue.

Thanks,
-- 
Fita Adrian
