Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2G0Kmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:42:36 -0400
Received: from mga10.intel.com ([192.55.52.92]:30355 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011Ab2G0Kme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:42:34 -0400
Subject: Re: [PATCH] efi: Build EFI stub with EFI-appropriate options
From: Matt Fleming <matt.fleming@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <1343340000-7587-1-git-send-email-mjg@redhat.com>
References: <1343340000-7587-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 27 Jul 2012 11:42:24 +0100
Message-ID: <1343385744.5502.4.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 18:00 -0400, Matthew Garrett wrote:
> We can't assume the presence of the red zone while we're still in a boot
> services environment, so we should build with -fno-red-zone to avoid
> problems. Change the size of wchar at the same time to make string handling
> simpler.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/boot/compressed/Makefile |    3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Matt Fleming <matt.fleming@intel.com>

