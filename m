Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2CXElK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 00:41:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59636 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab2CXElH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 00:41:07 -0400
Message-ID: <4F6D504B.4000101@zytor.com>
Date: Fri, 23 Mar 2012 21:40:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <201203240402.38749.trenn@suse.de>
In-Reply-To: <201203240402.38749.trenn@suse.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 08:02 PM, Thomas Renninger wrote:
> Whatabout Multiboot(2):
> http://en.wikipedia.org/wiki/Multiboot_Specification
> http://www.gnu.org/software/grub/manual/multiboot/multiboot.html
> 
> They do it similar to 2, but without specifying the data of the
> files like you do with type.
> 
> It's a bigger thing, but I could imagine there are some guys who would
> be willing to give it a try. I remember I googled a multiboot patch
> which got submitted to lkml long time ago.
> 
> It has it pros and cons, but should show up in such a discussion.
> 

Unfortunately Multiboot is defective in way too many ways, beginning
with its insistence of entering past the firmware point of no return,
which means the bootloader has to do a lot of work (this has been proven
to be a nonworkable solution) and no support for relocation.

So that is not an option.

	-hpa


