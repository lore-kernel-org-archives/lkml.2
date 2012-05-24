Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2EXNYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:24:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37311 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2EXNYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:24:48 -0400
Date: Thu, 24 May 2012 14:24:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Bdale Garbee <bdale@gag.com>
Subject: Re: [PATCH] acpi/video: Don't restore backlight to 0 at boot time
Message-ID: <20120524132443.GA21231@srcf.ucam.org>
References: <1325321547-20637-1-git-send-email-keithp@keithp.com>
 <20120103221954.GA2313@srcf.ucam.org>
 <86ehqajbkr.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ehqajbkr.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:13:40AM -0700, Keith Packard wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> 
> > ACPI arguably does define 0 as being off (this is exceedingly poorly 
> > defined), but I'm not entirely happy with this - the firmware makes its 
> > behaviour conditional on the OS version. I'd really like to see an 
> > updated version of the Intel opregion spec to get a better idea of what 
> > we're meant to be doing here, but the last one made public was
> > ancient.
> 
> Kernel 3.4 continues to break on this machine; I'd love to know how to
> get a suitable fix upstreamed...


Still waiting for that spec.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
