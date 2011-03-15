Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab1COL1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:27:32 -0400
Received: from foo.stuge.se ([213.88.146.6]:45297 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757264Ab1COL13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:27:29 -0400
Message-ID: <20110315112724.6729.qmail@stuge.se>
Date: Tue, 15 Mar 2011 12:27:24 +0100
From: Peter Stuge <peter@stuge.se>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Matthew Garrett <mjg@redhat.com>,
	Len Brown <lenb@kernel.org>, Alan Cox <alan@linux.intel.com>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com> <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk> <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl> <b7da2f$qnp1ps@fmsmga001.fm.intel.com> <5060ae708cceef8df998d3f59be5d246.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5060ae708cceef8df998d3f59be5d246.squirrel@webmail.greenhost.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> Everything would be a lot simpler if the BIOSes were open source.

coreboot has existed for about eleven years and some 250 mainboards of
varying shapes and sizes (from laptop to server) are supported, but it's
only just recently that things are really taking off, with the code
release from AMD to initialize their most recent Fusion platform.

http://www.coreboot.org/Welcome_to_coreboot
http://blogs.amd.com/work/2011/02/28/amd-coreboot/
http://news.slashdot.org/story/11/03/04/1736241/AMD-Provides-Fusion-Support-For-Coreboot


//Peter
