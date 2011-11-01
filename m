Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab1KAQrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:47:47 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42731 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1KAQrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:47:45 -0400
Date: Tue, 1 Nov 2011 12:47:26 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pci@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v5)
Message-ID: <20111101164726.GA14141@hmsreliant.think-freely.org>
References: <1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
 <20110930143211.5ab39c02@stein>
 <20110930153321.GA31760@hmsreliant.think-freely.org>
 <CAErSpo56QU78RHE0UOcvcT5iwcis1o_Ue=ZLPQ3GhdB483-L4Q@mail.gmail.com>
 <20110930165403.GB31760@hmsreliant.think-freely.org>
 <20111006083607.2c4eb9a5@jbarnes-desktop>
 <20111006171208.GB22462@hmsreliant.think-freely.org>
 <CAErSpo4bEcubO56hZ+PWZc0SdVEroyOmsxDtc_bBAJrxBKmAOQ@mail.gmail.com>
 <20111006180818.GD22462@hmsreliant.think-freely.org>
 <20111014092148.21158b85@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014092148.21158b85@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: 0.1 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 09:21:48AM -0700, Jesse Barnes wrote:
> On Thu, 6 Oct 2011 14:08:18 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > This patch adds a per-pci-device subdirectory in sysfs called:
> > /sys/bus/pci/devices/<device>/msi_irqs
> > 
> > This sub-directory exports the set of msi vectors allocated by a given
> > pci device, by creating a numbered sub-directory for each vector beneath
> > msi_irqs.  For each vector various attributes can be exported.  Currently the
> > only attribute is called mode, which tracks the operational mode of that vector
> > (msi vs. msix)
> > 
> 
> Ok this adds new ABI in the form of sysfs files so I want to make sure
> it's ok.
> 
> Matthew has dreams of a more sophisticated MSI-X management scheme, but
> it sounds to me like that will mostly affect the driver interfaces and
> shouldn't be incompatible with the sysfs scheme you propose here.
> 
> If so, great, we can pull this in and maybe one day someone will
> implement better MSI-X support.
> 
> If not, I'd like to hear objections now; Neil has been responsive and
> fixed several issues.  I don't want to block his patch unless we have
> something concrete that it conflicts with.
> 
> Thanks,
> -- 
> Jesse Barnes, Intel Open Source Technology Center
Ping Jesse, has something gone awry here? I've not seen this show up in your
tree yet.

Thanks & Regards
Neil



