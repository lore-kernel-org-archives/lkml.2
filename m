Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab2EWUVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:21:37 -0400
Received: from mga10.intel.com ([192.55.52.92]:47526 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560Ab2EWUVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:21:36 -0400
Subject: Re: [PATCH 1/3] x86: Expand EFI GOP handle search
From: Matt Fleming <matt.fleming@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <1337796526-3649-1-git-send-email-mjg@redhat.com>
References: <1337796526-3649-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Wed, 23 May 2012 21:21:13 +0100
Message-ID: <1337804473.3807.1.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 14:08 -0400, Matthew Garrett wrote:
> Some UEFI implementations provide multiple GOP handles, with one acting
> as a splitter device to handle the case of multiple outputs being present.
> The downside of this approach is that the console splitter device may
> report an inaccurate stride value. We currently get around this by looking
> for a device that implements the PCI IO protocol. However, this fails on
> some devices - the GOP may be attached to the display device rather than
> the GPU. We can handle that scenario by looking for a handle with an EDID
> protocol attached to it.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/boot/compressed/eboot.c |   27 ++++++++++++++++-----------
>  include/linux/efi.h              |    3 +++
>  2 files changed, 19 insertions(+), 11 deletions(-)

Seems fair enough. Thanks Matthew.

Acked-by: Matt Fleming <matt.fleming@intel.com>


