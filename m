Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab1LOPsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:48:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58873 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1LOPsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:48:52 -0500
Date: Thu, 15 Dec 2011 15:48:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024
 bytes
Message-ID: <20111215154850.GA10582@srcf.ucam.org>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
 <1323896791-10858-4-git-send-email-mjg@redhat.com>
 <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com>
 <20111214223950.GA29264@srcf.ucam.org>
 <CAGTjWtARm_OA0qy2Cvtc-rrPFpH2+2QdFw4CvBAo-PJsfX6t6w@mail.gmail.com>
 <20111215154356.GA10486@srcf.ucam.org>
 <4EEA1664.1050402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEA1664.1050402@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 07:46:44AM -0800, H. Peter Anvin wrote:
> On 12/15/2011 07:43 AM, Matthew Garrett wrote:
> >
> >We'll pretty much definitely want to be able to read values>  1024 once
> >people start shoving keys in there. The PAGE_SIZE limit is one that I'd
> >forgotten about, though.
> >
> 
> The jump from 1024 to 4096 seems to not be very long... hence I
> think we may need a different approach.

Yeah. I'll start thinking about the most sensible filesystem interface 
for this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
