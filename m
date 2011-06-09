Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1FIPfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:35:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46608 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1FIPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:35:48 -0400
Date: Thu, 9 Jun 2011 16:35:38 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Jones <pjones@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: CONFIG_EFI should select CONFIG_RELOCATABLE
Message-ID: <20110609153538.GA29274@srcf.ucam.org>
References: <1307629964-31658-1-git-send-email-mjg@redhat.com>
 <4DF0DAAB.7010005@zytor.com>
 <4DF0DB8D.5080207@redhat.com>
 <4DF0E584.2030101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF0E584.2030101@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 08:23:48AM -0700, H. Peter Anvin wrote:
> On 06/09/2011 07:41 AM, Peter Jones wrote:
> >>
> >> Can we make this a depends on instead of select?
> > 
> > Seems weird to me - when you're configuring the kernel, you're more likely
> > to know that you want EFI than to remember that that requires relocation.
> > 
> 
> Yes, but "select" is handled very poorly by Kconfig.

I think it's safe in this case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
