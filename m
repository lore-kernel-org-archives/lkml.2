Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2GZOBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:01:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab2GZOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:01:31 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andre Przywara <andre.przywara@amd.com>
Subject: Re: [PATCH 0/8] acpi-cpufreq: Move modern AMD cpufreq support to acpi-cpufreq
Date: Thu, 26 Jul 2012 16:01:22 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: cpufreq@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
In-Reply-To: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201207261601.23973.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 26, 2012 02:28:36 PM Andre Przywara wrote:
> The programming model for cpufreq on current AMD CPUs is almost
> identical to the one used on Intel and VIA hardware. This patchset
> merges support into acpi-cpufreq and removes it from powernow-k8.
 
> This patchset is heavily based on Matthew Garrett's V4 from last July.
> The boosting part has been mostly reworked and documentation for it
> has been added. Also there was a need for (yet another) BIOS quirk
> on AMD desktop boards.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>

I had a look at Matthew's patches and I like the idea.

I didn't review Andre's in detail, but if they are based on
Matthew's and I expect they got some testing, I guess it should
be fine to push them with the next merge window.

  Thomas
