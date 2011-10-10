Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1JJR7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:59:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52553 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1JJR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:59:14 -0400
Date: Mon, 10 Oct 2011 19:59:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: fix typos in Documentation/edac.txt and
 Documentation/filesystems/ext4.txt
Message-ID: <20111010175905.GB29415@aftab>
References: <20111010163245.B6B4B281C28@ip52.ipax.at>
 <4E931F78.7050007@ipax.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E931F78.7050007@ipax.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 12:38:16PM -0400, Raoul Bhatia [IPAX] wrote:
> Fixing trivial typos in
> Documentation/edac.txt and
> Documentation/filesystems/ext4.txt
> 
> patch for current git head checkout from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> Signed-off-by: Raoul Bhatia <r.bhatia@ipax.at>
> ---
> diff --git a/Documentation/edac.txt b/Documentation/edac.txt
> index 249822c..8ba7bb4 100644
> --- a/Documentation/edac.txt
> +++ b/Documentation/edac.txt
> @@ -643,7 +643,7 @@ There is a three level tree beneath the above 'edac' 
> directory. For example,
>   the 'test_device_edac' device (found at the bluesmoke.sourceforget.net 
> website)
>   installs itself as:
> 
> -	/sys/devices/systm/edac/test-instance
> +	/sys/devices/system/edac/test-instance
> 
>   in this directory are various controls, a symlink and one or more 
> 'instance'
>   directorys.
> diff --git a/Documentation/filesystems/ext4.txt 
> b/Documentation/filesystems/ext4.txt
> index 232a575..a8356c3 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -352,7 +352,7 @@ noinit_itable		Do not initialize any uninitialized 
> inode table
>   init_itable=n		The lazy itable init code will wait n times the
>   			number of milliseconds it took to zero out the
>   			previous block group's inode table.  This
> -			minimizes the impact on the systme performance
> +			minimizes the impact on the system performance
>   			while file system's inode table is being initialized.
> 
>   discard			Controls whether ext4 should issue discard/TRIMa

Right, a couple of suggestions:

* please don't mix different subsystems in a single patch: EDAC should be one
patch and fs another.

* Documentation/edac.txt is pretty old and has more errors than this one
so it would be much better to create a single patch which scrubs that
file properly and thoroughly.

Also, while you're at it, please run the driver and verify that all the
functionality described there actually works and document any changes
you might find which are deviating from the document. And if anything is
broken, you might even try to fix it, if you'd like :-) - patches are
always welcome.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
