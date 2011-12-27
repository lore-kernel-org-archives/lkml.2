Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1L0Qoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 11:44:37 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35685 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1L0Qof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 11:44:35 -0500
Date: Tue, 27 Dec 2011 16:44:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: HP Envy 17 3D BIOS reports "Thermal Shutdown" on every reboot
 despite no thermal problems
Message-ID: <20111227164434.GB23245@srcf.ucam.org>
References: <CAGZ=bqKqO328BQa7+0S-GNfmvgKurcB1Z66qbCMT7Fu3G=7Leg@mail.gmail.com>
 <20111221182817.GA25036@srcf.ucam.org>
 <CAGZ=bqKm55ThEq3_pDWemVAZJzfiU=4x=U2_4inoy-tZjDnxgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGZ=bqKm55ThEq3_pDWemVAZJzfiU=4x=U2_4inoy-tZjDnxgg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 11:43:23AM -0500, Kyle Moffett wrote:
> On Wed, Dec 21, 2011 at 13:28, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Try the patch I sent entitled "[PATCH] ACPI: Evaluate thermal trip
> > points before reading temperature".
> 
> Perfect, thank you very much!
> 
> Tested-by: Kyle Moffett <kyle@moffetthome.net>
> 
> Any idea when it will get merged?

When Len picks it up. I'll go back through my queue and see what's 
missing from mainline, then send some pings.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
