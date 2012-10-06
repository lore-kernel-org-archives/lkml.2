Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2JFTco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 15:32:44 -0400
Received: from mga12.intel.com ([143.182.124.36]:16044 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752507Ab2JFTcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 15:32:43 -0400
Message-ID: <1349551935.15966.59.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH 1/3] efi: Add support for a UEFI variable filesystem
From: Matt Fleming <matt.fleming@intel.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, glin@suse.com,
        Lee@grenadilla.canonical.com, Chun-Yi <jlee@suse.com>,
        Matthew Garrett <mjg@redhat.com>, Peter Jones <pjones@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 06 Oct 2012 20:32:15 +0100
In-Reply-To: <1349416496.810727.310563927016.1.gpush@pecola>
References: <1349416496.810727.310563927016.1.gpush@pecola>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 13:54 +0800, Jeremy Kerr wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> The existing EFI variables code only supports variables of up to 1024
> bytes. This limitation existed in version 0.99 of the EFI specification,
> but was removed before any full releases. Since variables can now be
> larger than a single page, sysfs isn't the best interface for this. So,
> instead, let's add a filesystem. Variables can be read, written and
> created, with the first 4 bytes of each variable representing its UEFI
> attributes. The create() method doesn't actually commit to flash since
> zero-length variables can't exist per-spec.
> 
> Updates from Jeremy Kerr <jeremy.kerr@canonical.com>.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

Thanks, I've applied this series.

