Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2HEVOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:14:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42779 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab2HEVOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:14:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/8] acpi-cpufreq: Move modern AMD cpufreq support to acpi-cpufreq
Date: Sun, 5 Aug 2012 23:20:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Andre Przywara <andre.przywara@amd.com>, cpufreq@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
In-Reply-To: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208052320.14712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 26, 2012, Andre Przywara wrote:
> The programming model for cpufreq on current AMD CPUs is almost identical
> to the one used on Intel and VIA hardware. This patchset merges support
> into acpi-cpufreq and removes it from powernow-k8.
> 
> This patchset is heavily based on Matthew Garrett's V4 from last July.
> The boosting part has been mostly reworked and documentation for it
> has been added. Also there was a need for (yet another) BIOS quirk
> on AMD desktop boards.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>

Peter, any objection to this series?

Rafael

