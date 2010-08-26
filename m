Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0HZSMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:12:10 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:64968 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0HZSMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:12:09 -0400
Date: Thu, 26 Aug 2010 14:11:51 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: =?ISO-8859-15?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
In-reply-to: <20100825094925.GA3632@pema>
Message-id: <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain>
References: <20100825094925.GA3632@pema>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-139430450-1282846313=:2062"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-139430450-1282846313=:2062
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

>     The Iris machines from EuroBraille do not have APM or ACPI support
>     to shut themselves down properly.

According to
www.multitech.com/en_us/news/articles/success_stories/eurobraille.pdf :

"EURObraille¢s latest invention is the IRIS portable assistant.
 The use of a powerful microprocessor coupled with the most advanced
 Microsoft Windows operating system provides the blind with a powerful
 computing solution"

What version of Microsoft Windows ships on this box?
Does it run in ACPI mode?  Does it power-off successfully?

Does Linux run in ACPI mode?
Please send along the dmesg from a Linux kernel built with:

CONFIG_ACPI=y
CONFIG_ACPI_DEBUG=y

thanks,
Len Brown, Intel Open Source Technology Center

--8323328-139430450-1282846313=:2062--
