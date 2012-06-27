Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2F0UBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:01:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51428 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab2F0UBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:01:03 -0400
Date: Wed, 27 Jun 2012 21:01:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: UEFI Secure boot using qemu-kvm
Message-ID: <20120627200100.GA10300@srcf.ucam.org>
References: <1340818445.3175.73.camel@dabdike.int.hansenpartnership.com>
 <20120627181503.GA7775@srcf.ucam.org>
 <1340825704.3175.88.camel@dabdike.int.hansenpartnership.com>
 <20120627193806.GA10091@srcf.ucam.org>
 <1340826809.3175.89.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340826809.3175.89.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 08:53:29PM +0100, James Bottomley wrote:
> /usr/include/efi/x86_64/efibind.h:88:1: error: unknown type name
> ‘uint64_t’

Ok, so some difference in toolchains is pulling in stdint.h for me but 
not for you.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
