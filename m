Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0EXM4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 08:56:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45653 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0EXM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 08:56:43 -0400
Date: Mon, 24 May 2010 13:56:28 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ben Skeggs <bskeggs@redhat.com>,
       dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH -next] nouveau: fix acpi_lid_open undefined
Message-ID: <20100524125628.GA14278@srcf.ucam.org>
References: <20100522170459.4c89723d.sfr@canb.auug.org.au> <20100523170040.3c4aa87c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100523170040.3c4aa87c.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 05:00:40PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_ACPI_BUTTON=m (and probably when ACPI_BUTTON is not enabled)
> and NOUVEAU is built-in (not as a loadable module):

Won't this result in a behavioural difference? The desirable outcome is 
that that configuration be impossible, not for that configuration to 
build but be buggy.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
