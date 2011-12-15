Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab1LOPpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:45:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41838 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1LOPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:44:59 -0500
Date: Thu, 15 Dec 2011 15:44:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024
 bytes
Message-ID: <20111215154456.GB10486@srcf.ucam.org>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
 <1323896791-10858-4-git-send-email-mjg@redhat.com>
 <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com>
 <20111214223950.GA29264@srcf.ucam.org>
 <4EE926D2.3030803@zytor.com>
 <20111214225728.GA29582@srcf.ucam.org>
 <4EE92A0C.2040207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE92A0C.2040207@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 02:58:20PM -0800, H. Peter Anvin wrote:
> On 12/14/2011 02:57 PM, Matthew Garrett wrote:
> > Yes, but we'd break existing userspace.
> > 
> 
> Obviously.  However, you indicated above that that might be acceptable
> -- how many things use this ABI to set variables?

Ah, sorry - my suggestion had been to add an additional interface, not 
just replace the existing one. efibootmgr is the only userland I know of 
that interacts directly, but it's entirely possible that there are 
others - I'd guess Google have something.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
