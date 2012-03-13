Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab2CMS6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:58:50 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:37281 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756039Ab2CMS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:58:48 -0400
Message-ID: <4F5F98E8.3070900@xenotime.net>
Date: Tue, 13 Mar 2012 11:58:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Shawn Landden <shawnlandden@gmail.com>
CC: mmarek@suse.cz, andi@lisas.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: scripts/patch-kernel should be able to digest
 kernel.org hosted .xz patches
References: <1331590417-10050-1-git-send-email-shawnlandden@gmail.com>
In-Reply-To: <1331590417-10050-1-git-send-email-shawnlandden@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 03:13 PM, Shawn Landden wrote:

> kernel.org is hosting patches and kernel compressed with xz (lzma2+). Allow
> scripts/patch-kernel to decompress these files.

Other than xz file decompression, does scripts/patch-kernel
work for you in Linux 3.x kernel trees?


> Signed-off-by: Shawn Landden <shawnlandden@gmail.com>
> ---
>  scripts/patch-kernel |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/patch-kernel b/scripts/patch-kernel
> index 20fb25c..d000ea3 100755
> --- a/scripts/patch-kernel
> +++ b/scripts/patch-kernel
> @@ -116,6 +116,10 @@ findFile () {
>  		ext=".bz2"
>  		name="bzip2"
>  		uncomp="bunzip2 -dc"
> +  elif [ -r ${filebase}.xz ]; then
> +                ext=".xz"
> +                name="xz"
> +                uncomp="xz -dc"
>    elif [ -r ${filebase}.zip ]; then
>  		ext=".zip"
>  		name="zip"



-- 
~Randy
