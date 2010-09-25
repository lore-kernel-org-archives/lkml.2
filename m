Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0IYQJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 12:09:33 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:40817 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0IYQJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 12:09:31 -0400
Date: Sat, 25 Sep 2010 12:09:11 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-pm@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: intel_idle (Lenovo ideapad S10-3)
In-reply-to: <4C8DE00F.7070801@canonical.com>
Message-id: <alpine.LFD.2.00.1009251201150.17910@localhost.localdomain>
References: <4C8DE00F.7070801@canonical.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I test myself which says when CONFIG_CPU_IDLE=y, Lenovo ideapad S10-3 can
> not boot. The CPU is Atom N450, and I also find the report[2] that says intel_idle
> works fine with N450.
> 
> I do not have much knowledge about intel_idle. is there any similar report that on
> some machine intel_idle halt the system or any suggestion for next step debug?
> 
> 
> [1] http://launchpad.net/bugs/634702
> [2] http://www.spinics.net/lists/linux-pm/msg21334.html

Please test the fix here:
http://bugs.meego.com/show_bug.cgi?id=7093

thanks,
-Len

