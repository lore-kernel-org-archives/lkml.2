Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2CTX5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:57:55 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:39649 "EHLO
	homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751996Ab2CTX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=l5xF2V+mS2Qc7ywF9lXZp40EogPu2Ux1Xxz9xZ/Jt2ylXnv3U4iP6n6/gCITu
	OpqLL2uQIeDslhByQ4w3bmHjISxtbYtde13/Vx4685TZWLnKqW0kd33sDboZzV1J
	EvKFmF4rc/LGCP/Tig0nwv+fqOT85nsullDxmH+xjaTQVc=
Message-ID: <4F69197E.7020607@shealevy.com>
Date: Tue, 20 Mar 2012 19:57:50 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20120311 Thunderbird/9.0.1
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garret <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 0/3] x86, efi: EFI boot stub documentation
References: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 10:18 AM, Matt Fleming wrote:
> From: Matt Fleming<matt.fleming@intel.com>
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
>    x86, efi: Only close open files in error path
>    x86, efi; Add EFI boot stub console support
>    x86, efi: Add EFI boot stub documentation
>
>   Documentation/x86/efi-stub.txt   |   65 ++++++++++++++++++++++++++++
>   arch/x86/Kconfig                 |    2 +
>   arch/x86/boot/compressed/eboot.c |   88 ++++++++++++++++++++++++++++++-------
>   arch/x86/boot/compressed/eboot.h |    6 +++
>   4 files changed, 144 insertions(+), 17 deletions(-)
>   create mode 100644 Documentation/x86/efi-stub.txt
>

Anyone know if we can expect these to be in mainline by the end of the 
merge window?
