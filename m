Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1HDV4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:56:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50804 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab1HDV4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:56:24 -0400
Date: Thu, 4 Aug 2011 22:56:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't
 already
Message-ID: <20110804215619.GA7101@srcf.ucam.org>
References: <cover.1312386029.git.luto@mit.edu>
 <5bec80947da3fb72f2f18fbe6d924a69f83fbed9.1312386029.git.luto@mit.edu>
 <alpine.LFD.2.02.1108031214470.22067@x980>
 <CAObL_7GuAmzyjo5AmYxbTeiAqFtVk1N+opzWEzwJu8Mgrvts7g@mail.gmail.com>
 <CAObL_7FNa20Hsd0v-hs1vz=ejnkdaT+Yr=wwM681GbZJiuLkMQ@mail.gmail.com>
 <alpine.LFD.2.02.1108031514550.22067@x980>
 <20110804194117.GA5265@srcf.ucam.org>
 <alpine.LFD.2.02.1108041751360.24626@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1108041751360.24626@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 05:54:04PM -0400, Len Brown wrote:
> > We can't trust BIOS authors to get things right. Where we can reliably 
> > fix up things that are broken, we should do so.
> 
> How about if we can get a BIOS fix for this brand new system,
> then we shall not clutter the kernel with a workaround,
> otherwise we shall.

It's a pretty good rule of thumb that if a BIOS bug is present in one 
BIOS it's present in others, but the users will just never notice.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
