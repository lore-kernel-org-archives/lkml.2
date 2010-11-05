Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0KEKYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 06:24:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab0KEKYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 06:24:51 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] X86: Cleanup idle= internal variables by getting rid of idle_halt idle_nomwait
Date: Fri, 5 Nov 2010 11:24:49 +0100
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        stable@kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <201011021441.09258.trenn@suse.de> <alpine.LFD.2.00.1011030150560.3378@localhost.localdomain> <201011031706.15248.trenn@suse.de>
In-Reply-To: <201011031706.15248.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011051124.49973.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Wednesday 03 November 2010 17:06:14 Thomas Renninger wrote:
> On Wednesday 03 November 2010 07:33:54 Len Brown wrote:
...
> > That function and all these idle workaround flags
> > need to be re-whacked.
> Whatabout this (compile tested (on x86_64/ia64)).
> Adding lkml as this affects x86 core code.
as this mostly affects intel_idle and acpi processor driver,
can you apply this one to your acpi test branch if you are
ok with it.

Thanks,

     Thomas
