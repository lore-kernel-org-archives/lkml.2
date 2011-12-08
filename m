Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1LHJ0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:26:36 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48238 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021Ab1LHJ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:26:34 -0500
Subject: Re: [PATCH] x86: Remove spurious EFI error message
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1301315233-2720-1-git-send-email-mjg@redhat.com>
References: <1301315233-2720-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 09:26:23 +0000
Message-ID: <1323336383.3894.63.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 08:27 -0400, Matthew Garrett wrote:
> The EFI memory descriptor services can return a descriptor that is larger
> than the specification, and right now we give a warning message in that
> situation. This behaviour is permitted by the specification, so we should
> just drop the warning.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)

Matthew, any plans on getting this merged?

-- 
Matt Fleming, Intel Open Source Technology Center

