Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2CXJZD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 05:25:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53069 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2CXJY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:24:57 -0400
Date: Sat, 24 Mar 2012 10:24:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
Message-ID: <20120324092451.GA3352@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Thomas Renninger <trenn@suse.de>,
	eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
	robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
 <201203240242.07724.trenn@suse.de>
 <4F6D2AF8.3070707@zytor.com>
 <201203240402.38749.trenn@suse.de>
 <4F6D50DD.4050306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F6D50DD.4050306@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 09:43:09PM -0700, H. Peter Anvin wrote:
> By the way, if "relying on the bootloader" was an option in any way then
> we would already have a solution in the form of the kernel data linked
> list.  Unfortunately to the best of my knowledge not a single bootloader
> provides support for it.

... and that's unfortunate because if we had that support, we wouldn't
need to redo the initrd each time microcode or BIOS tables change but
simply point the boot loader to the updated images.

:-(

Btw, hpa, didn't you have someone working on early microcode loading,
any results there?

Thanks.

-- 
Regards/Gruss,
    Boris.
