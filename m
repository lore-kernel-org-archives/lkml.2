Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2GZTwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:52:42 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58993 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab2GZTwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:52:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 0/8] acpi-cpufreq: Move modern AMD cpufreq support to acpi-cpufreq
Date: Thu, 26 Jul 2012 21:58:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Andre Przywara <andre.przywara@amd.com>, cpufreq@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com> <201207261601.23973.trenn@suse.de>
In-Reply-To: <201207261601.23973.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201207262158.25936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 26, 2012, Thomas Renninger wrote:
> On Thursday, July 26, 2012 02:28:36 PM Andre Przywara wrote:
> > The programming model for cpufreq on current AMD CPUs is almost
> > identical to the one used on Intel and VIA hardware. This patchset
> > merges support into acpi-cpufreq and removes it from powernow-k8.
>  
> > This patchset is heavily based on Matthew Garrett's V4 from last July.
> > The boosting part has been mostly reworked and documentation for it
> > has been added. Also there was a need for (yet another) BIOS quirk
> > on AMD desktop boards.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> 
> I had a look at Matthew's patches and I like the idea.
> 
> I didn't review Andre's in detail, but if they are based on
> Matthew's and I expect they got some testing, I guess it should
> be fine to push them with the next merge window.

Good, thanks for your opinion, it helps a lot! :-)

I'll have a deeper look at the patches in the next couple of days and will
queue them up for v3.7 if I don't find anything objectionable in them.

Thanks,
Rafael
