Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0E1IHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:07:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:55325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab0E1IGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:06:52 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] idle-test patches queued for upstream
Date: Fri, 28 May 2010 10:07:34 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <1274928151-30919-1-git-send-email-lenb@kernel.org> <201005271045.33500.trenn@suse.de> <alpine.LFD.2.00.1005272023510.24823@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005272023510.24823@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005281007.34706.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 May 2010 02:59:07 Len Brown wrote:
> > > ... we think we can do better than ACPI.
> 
> > Why exactly? Is there any info missing in the ACPI tables?
> > Or is this just to be more independent from OEMs?
> 
> ACPI has a few fundmental flaws here.  One is that it reports
> exit latency instead of break-even power duration.
> The other is that it requires a BIOS writer to
> get the tables right.
This is a general ACPI problem...
 
> > Using ACPI table based C-states by default and using
> > intel_idle.enable=1
> > or similar for workarounds sounds safer.
> > At least as long as the driver is experimental.
> 
> I plan to remove the EXPERIMENTAL in 1 release.
> 
> > Does Windows use ACPI C-state info for idle?

> Yes, Windows uses ACPI.
> On the Dell above, that is why Linux consumes 15% less idle power
> and why Linux can take advantage of turbo mode and Windows can not.
You always propageted to stay Windows compatible...
Now we go the untested way.
Let's see how much machines will break...

Thanks for clarifications,

    Thomas
