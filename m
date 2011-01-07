Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1AGGIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:08:37 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:59363 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1AGGIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:08:34 -0500
Date: Fri, 07 Jan 2011 01:08:28 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 0/5] PM / ACPI: Fix problems with ACPI NVS saving related
 to using ioremap_cache() by ACPI
In-reply-to: <201101070141.02951.rjw@sisk.pl>
Message-id: <alpine.LFD.2.02.1101070106020.20858@x980>
References: <201101070141.02951.rjw@sisk.pl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you want me to take these patches to my tree or are you going to push them

I've included them in acpi-test, and will include in my .38 push.

thanks,
-Len Brown, Intel Open Source Technology Center

