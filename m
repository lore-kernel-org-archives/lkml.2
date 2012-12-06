Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424341Ab2LFQR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:17:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42007 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423988Ab2LFQR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:17:28 -0500
Date: Thu, 6 Dec 2012 17:17:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86: ptrace.c only needs export.h and not the full
 module.h
Message-ID: <20121206161725.GA10351@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@linux.intel.com>
References: <1354793622-8497-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354793622-8497-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 06:33:42AM -0500, Paul Gortmaker wrote:
> Commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a ("x86-32: Export
> kernel_stack_pointer() for modules") added an include of the
> module.h header in conjunction with adding an EXPORT_SYMBOL_GPL
> of kernel_stack_pointer.
> 
> But module.h should be avoided for simple exports, since it in turn
> includes the world.  Swap the module.h for export.h instead.

If this is the preferred include for EXPORT_SYMBOL* stuff now, maybe we
should hold this down somewhere in writing or add it to checkpatch?

Thanks.

-- 
Regards/Gruss,
    Boris.
