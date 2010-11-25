Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0KYO74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:59:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:54575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab0KYO7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:59:55 -0500
Message-ID: <4CEE79E9.1060204@suse.cz>
Date: Thu, 25 Nov 2010 15:59:53 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: add ata_port_operations to the
 list of ops that ought to be const.
References: <684104.78681.qm@smtp127.mail.ukl.yahoo.com>
In-Reply-To: <684104.78681.qm@smtp127.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Andy and Joe to CC. Lionel, you should consult the MAINTAINERS
file and/or the get_maintainer.pl script and/or the git history to find
suitable addresses to CC.

Michal

On 8.11.2010 07:29, Lionel Debroux wrote:
> Patch against mainline.
> 
> ---
> 
> Subject: [PATCH] scripts/checkpatch.pl: add ata_port_operations to the list of ops that ought to be const.
> 
> I noticed that many ata_port_operations instances are constified
> by the grsecurity patch, so it may be desirable to reduce the
> introduction of non-const instances through checkpatch.pl.
> 
> Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
> ---
>  scripts/checkpatch.pl |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index e3c7fc0..33fab2e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2810,6 +2810,7 @@ sub process {
>  # check for various ops structs, ensure they are const.
>  		my $struct_ops = qr{acpi_dock_ops|
>  				address_space_operations|
> +				ata_port_operations|
>  				backlight_ops|
>  				block_device_operations|
>  				dentry_operations|

