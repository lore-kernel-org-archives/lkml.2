Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1KOUmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:42:05 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48405 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1KOUmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:42:03 -0500
Date: Tue, 15 Nov 2011 20:42:01 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dienet <dienet@poczta.fm>
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: Resuming from hibernation on T61 with nvidia
Message-ID: <20111115204201.GA10466@srcf.ucam.org>
References: <op.v4z4ihs2wcw97g@localhost>
 <20111115195832.GA9384@srcf.ucam.org>
 <op.v4z8zxnwwcw97g@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.v4z8zxnwwcw97g@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 09:39:23PM +0100, dienet wrote:
> On Tue, 15 Nov 2011 20:58:32 +0100, Matthew Garrett
> <mjg59@srcf.ucam.org>  wrote:
> 
> >Does the same thing happen if you use nouveau rather than the nvidia
> >drivers?
> 
> Can not answer that, but this is not happening when using nv X11 driver.

In that case it's almost certainly something you need to bring up with 
nvidia.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
