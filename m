Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0LIGNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:13:09 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:38409 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0LIGNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:13:07 -0500
Date: Thu, 09 Dec 2010 01:12:57 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jack Steiner <steiner@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, hmh@hmh.eng.br, mingo@elte.hu,
        tglx@linutronix.de, tony.luck@gmail.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, gbeshers@sgi.com
Subject: Re: [RFC  - V2] - Mapping ACPI tables as CACHED
In-reply-to: <20101209035025.GB6697@sgi.com>
Message-id: <alpine.LFD.2.00.1012090104320.27964@x980>
References: <20100722152220.GA18290@sgi.com>
 <20100724001449.GA9618@khazad-dum.debian.net> <4C743C0F.2010101@zytor.com>
 <20100826171704.GA21584@sgi.com> <4C76AD82.2030105@zytor.com>
 <20101208212244.GA24280@sgi.com> <4D00308B.2040009@zytor.com>
 <20101209035025.GB6697@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack,

I agree that we should try to map cached always,
and that we should try do the same thing on all platforms.

I favor continuing to map the tables in-place.
Yes, Toshiba has a quirk and we copy the tables there.
But frankly, we have no idea what the heck Toshiba is doing
and we don't want every platform to pay the price because
of some vendor specific evil.

Please send an upstream ready version of this RFC
(checkpatch clean), labled with "PATCH".

thanks,
Len Brown, Intel Open Source Technology Center


ps. acpidump can be updated to use /sys/firmware/acpi/tables
to get rid of the mmap stuff.  That is someplace on our todo list...

