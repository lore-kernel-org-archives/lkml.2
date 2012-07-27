Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab2G0Koq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:44:46 -0400
Received: from mga07.intel.com ([143.182.124.22]:59326 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751053Ab2G0Koo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:44:44 -0400
Subject: Re: [PATCH] X86: Improve GOP detection in the EFI boot stub
From: Matt Fleming <matt.fleming@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <1343340027-7641-1-git-send-email-mjg@redhat.com>
References: <1343340027-7641-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 27 Jul 2012 11:44:38 +0100
Message-ID: <1343385878.5502.5.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 18:00 -0400, Matthew Garrett wrote:
> We currently use the PCI IO protocol as a proxy for a functional GOP. This
> is less than ideal, since some platforms will put the GOP on output devices
> rather than the GPU itself. Move to using the conout protocol. This is not
> guaranteed per-spec, but is part of the consplitter implementation that
> causes this problem in the first place and so should be reliable.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/boot/compressed/eboot.c |   29 ++++++++++++++++-------------
>  arch/x86/boot/compressed/eboot.h |    4 ++++
>  2 files changed, 20 insertions(+), 13 deletions(-)

Acked-by: Matt Fleming <matt.fleming@intel.com>


