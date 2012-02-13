Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab2BMQO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:14:26 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36643 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754852Ab2BMQOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:14:25 -0500
Message-ID: <4F3936BE.8060003@xenotime.net>
Date: Mon, 13 Feb 2012 08:13:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, JF@linux.or.jp
Subject: Re: [PATCH] [trivial] Documentation: Fix broken URL "JF"
References: <1329141187-2158-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1329141187-2158-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 05:53 AM, Masanari Iida wrote:
> Fix broken URL for JF (Japanese FAQ).
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Adding JF Project email address to Cc: list for their
input.


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  Documentation/00-INDEX |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> index 65bbd26..a859507 100644
> --- a/Documentation/00-INDEX
> +++ b/Documentation/00-INDEX
> @@ -8,7 +8,7 @@ Please try and keep the descriptions small enough to fit on one line.
>  Following translations are available on the WWW:
>  
>     - Japanese, maintained by the JF Project (JF@linux.or.jp), at
> -     http://www.linux.or.jp/JF/
> +     http://linuxjf.sourceforge.jp/
>  
>  00-INDEX
>  	- this file.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
