Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2F0TiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:38:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37419 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2F0TiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:38:10 -0400
Date: Wed, 27 Jun 2012 20:38:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: UEFI Secure boot using qemu-kvm
Message-ID: <20120627193806.GA10091@srcf.ucam.org>
References: <1340818445.3175.73.camel@dabdike.int.hansenpartnership.com>
 <20120627181503.GA7775@srcf.ucam.org>
 <1340825704.3175.88.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340825704.3175.88.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 08:35:04PM +0100, James Bottomley wrote:

> I've tried to build pesign, but I have huge problems with the make
> process; how did you build it?

I checked it out and ran make. What problems ar eyou seeing?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
