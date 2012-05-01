Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2EATOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:14:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35723 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2EATOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:14:20 -0400
Date: Tue, 1 May 2012 14:14:08 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Adrian Fita <adrian.fita@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Ralf Jung <ralfjung-e@gmx.de>, Paolo Scarabelli <paolo@msw.it>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [bug?] Battery notifications produce flashing battery icon,
 syslog spam (Re: [PATCH 11/11] ACPI / Battery: Update information on info
 notification and resume)
Message-ID: <20120501191408.GD19143@burratino>
References: <201101062331.17079.rjw@sisk.pl>
 <201101062342.28168.rjw@sisk.pl>
 <20120501184534.GA31731@burratino>
 <4FA032EA.1090608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA032EA.1090608@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc-ing Andy)
Adrian Fita wrote:

> Also, searching on Google after "upowerd device
> removed:/org/freedesktop/UPower/devices/battery_BAT0", reveals much
> more bug reports with the exact issue.

Thanks.  That confirms the high CPU consumption in upowerd ---
see [1], for example.

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/987807
