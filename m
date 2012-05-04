Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2EDK1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:27:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35532 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab2EDK1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:27:39 -0400
Subject: Re: [PATCH 0/3] x86, efi: EFI boot stub documentation
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garret <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
References: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 May 2012 11:27:35 +0100
Message-ID: <1336127255.18999.53.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? I can't find these patches in tip.

On Fri, 2012-03-16 at 14:18 +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> Some people trying out the EFI stub have been confused about the
> syntax for the initrd= option, so this series adds some information to
> Documentation/x86. It also adds some helpful error messages, as
> previously if the user specified an incorrect initrd filename the
> machine just appeared to hang. Now at least it will print a message
> saying that it couldn't open the file.
> 
> The first patch is actually a bug fix for an issue where the wrong
> loop counter was used when trying to close initrd files in the error
> path, which caused the machine to hang because a garbage pointer was
> dereferenced.
> 
> Ideally I'd like to squeeze at least the last two patches in before
> v3.3 is released.
> 
> Matt Fleming (3):
>   x86, efi: Only close open files in error path
>   x86, efi; Add EFI boot stub console support
>   x86, efi: Add EFI boot stub documentation
> 
>  Documentation/x86/efi-stub.txt   |   65 ++++++++++++++++++++++++++++
>  arch/x86/Kconfig                 |    2 +
>  arch/x86/boot/compressed/eboot.c |   88 ++++++++++++++++++++++++++++++-------
>  arch/x86/boot/compressed/eboot.h |    6 +++
>  4 files changed, 144 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/x86/efi-stub.txt
> 



