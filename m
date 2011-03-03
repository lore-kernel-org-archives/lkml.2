Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab1CCNNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:13:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:36159 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1CCNNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:13:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,258,1297065600"; 
   d="scan'208";a="663440369"
Date: Thu, 3 Mar 2011 12:52:36 +0000
From: Alan Cox <alan@linux.intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: Use generic IGD opregion code for gma500
Message-ID: <20110303125236.1640d3b4@bob.linux.org.uk>
In-Reply-To: <20110303130724.GB22181@srcf.ucam.org>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
	<1298404994-2907-2-git-send-email-mjg@redhat.com>
	<alpine.LFD.2.02.1103022114250.12344@x980>
	<20110303114306.31114533@bob.linux.org.uk>
	<20110303130724.GB22181@srcf.ucam.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 13:07:24 +0000
Matthew Garrett <mjg@redhat.com> wrote:

> On Thu, Mar 03, 2011 at 11:43:06AM +0000, Alan Cox wrote:
> > On Wed, 02 Mar 2011 21:14:31 -0500 (EST)
> > Len Brown <lenb@kernel.org> wrote:
> > 
> > > applied to acpi-test
> > 
> > NAK this - with it applied the GMA500 driver oopses in the opregion
> > code
> 
> Awesome. Got a backtrace? I'm kind of lacking in hardware (and no,
> this is not a plea for some gma500)

I did try and pin it down a bit but didn't get anywhere useful. When I
have a bit more time I'll trace it in full.

