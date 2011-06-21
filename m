Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1FUPCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:02:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50393 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab1FUPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:02:21 -0400
Date: Tue, 21 Jun 2011 16:02:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mike Waychison <mikew@google.com>
Cc: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] efi: Add infrastructure for UEFI 2.0 runtime
 services
Message-ID: <20110621150210.GA7476@srcf.ucam.org>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
 <1307388985-7852-2-git-send-email-mjg@redhat.com>
 <4DFFCCD4.7070403@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFFCCD4.7070403@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 03:42:28PM -0700, Mike Waychison wrote:
> On 06/06/11 12:36, Matthew Garrett wrote:
> >We're currently missing support for any of the runtime service calls
> >introduced with the UEFI 2.0 spec in 2006. Add the infrastructure for
> >supporting them.
> 
> This patch looks like it introduced runtime_version in mainline, but
> I don't see where it gets zero.

Oops. Yeah, I'll fix that. Thanks!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
