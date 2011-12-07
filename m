Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1LGAdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:33:00 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:45322 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753959Ab1LGAc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:32:59 -0500
Message-ID: <4EDEC21E.4050103@xenotime.net>
Date: Tue, 06 Dec 2011 17:32:14 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Einon <mark.einon@gmail.com>
CC: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        Trivial patch monkey <trivial@kernel.org>
Subject: Re: [PATCH] [TRIVIAL] linux-next: Fixed spelling typo in types.h
References: <1323213494-21947-1-git-send-email-mark.einon@gmail.com>
In-Reply-To: <1323213494-21947-1-git-send-email-mark.einon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 03:18 PM, Mark Einon wrote:
> Spelling change, architetures -> architectures
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>

You should Cc: trivial@kernel.org also.
[done]

> ---
>  include/linux/types.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 57a9723..cbcef6e 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -188,7 +188,7 @@ typedef __u32 __bitwise __wsum;
>   * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
>   * common 32/64-bit compat problems.
>   * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
> - * architectures) and to 8-byte boundaries on 64-bit architetures.  The new
> + * architectures) and to 8-byte boundaries on 64-bit architectures.  The new
>   * aligned_64 type enforces 8-byte alignment so that structs containing
>   * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
>   * No conversions are necessary between 32-bit user-space and a 64-bit kernel.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
