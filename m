Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2IENkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:40:08 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37796 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2IENkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:40:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andre Przywara <andre.przywara@amd.com>
Subject: Re: [PATCH 0/8 v2] acpi-cpufreq: Move modern AMD cpufreq support to acpi-cpufreq
Date: Wed, 5 Sep 2012 15:46:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Thomas Renninger <trenn@suse.de>, Matthew Garret <mjg@redhat.com>,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
References: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
In-Reply-To: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201209051546.22590.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 04, 2012, Andre Przywara wrote:
> Hi,
> 
> now the second, revised version of the patch set. I now tested loading
> both drivers after each other in several combinations, after two bug
> fixes this now works as expected.
> I added a patch to move messages from powernow-k8 after the initialization
> phase, so it remains silent if driver loading fails.
> 
> I also rearranged the patches so that the powernow-k8 feature removal patch is
> now the last one and is somewhat optional. I still prefer to have it in,
> but it can be dropped if needed. Then powernow-k8 will still support modern
> AMD CPUs, but will emit a warning message.
> 
> Regards,
> Andre
> 
> Changes from v1:
> * added hints to Kconfig about CPU support
> * merge documentation from separate patch into the feature patch
> * add deprecation warning
> * prefix acpi-cpufreq warning messages with module name
> * bugfix: avoid boost init it driver registration failed
> * bugfix: fix module redirect request call (was not reached before)

I have applied the whole series to the linux-next branch of the linux-pm.git
tree, but I'm quite unsure about [7/8].  Is it really necessary?  I mean, since
we want users to switch to a different driver anyway, which already has a knob
providing the functionality in question, what's the point really?

Rafael
