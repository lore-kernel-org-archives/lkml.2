Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096Ab0H1Eok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 00:44:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60448 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0H1Eoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 00:44:39 -0400
Message-ID: <4C789432.5060402@canonical.com>
Date: Fri, 27 Aug 2010 21:44:34 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] .gitignore: ignore apparmor/rlim_names.h
References: <1282962309-3331-1-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1282962309-3331-1-git-send-email-yong.zhang0@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2010 07:25 PM, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang@windriver.com>
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Ah, yes thanks Yong, I did miss adding rlim_names.h to the git ignore file
when I switched it to be auto generated.

Signed-off-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/.gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/security/apparmor/.gitignore b/security/apparmor/.gitignore
> index 0a0a99f..4d995ae 100644
> --- a/security/apparmor/.gitignore
> +++ b/security/apparmor/.gitignore
> @@ -3,3 +3,4 @@
>  #
>  af_names.h
>  capability_names.h
> +rlim_names.h

