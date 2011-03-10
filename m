Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1CJAaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:30:35 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:47561 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753881Ab1CJAad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:30:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type:X-Identified-User;
	b=nPmpNNR+IKaoMsWp6z1yHihlDZuzRdvxvEWJPuO+2FpTQ655lzMt8Iz1lmh5Rq/fvPf0d8WqFKHQh05bkX/lCQj3iSpEYMtsSvT7vRNmQ2O+Fx8wKrbv2bxFESdJQMvd;
Date: Wed, 9 Mar 2011 16:30:23 -0800 (PST)
From: Randy Dunlap <rdunlap@xenotime.net>
X-X-Sender: rddunlap@chimera.site
To: Rob Landley <rlandley@parallels.com>
cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove more obsolete Documentation entries.
In-Reply-To: <4D77F557.3050002@parallels.com>
Message-ID: <alpine.LFD.2.00.1103091630001.2061@chimera.site>
References: <4D77F557.3050002@parallels.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Mar 2011, Rob Landley wrote:

> From: Rob Landley <rlandley@parallels.com>
>
> Time interpolators were removed in git 1f564ad6d41828
> Voyager support went away in git b6b6e2b112caf
>
> Signed-off-by: Rob Landley <rlandley@parallels.com>

Hi Rob,

I already have this patch queued.

> ---
>
> Documentation/00-INDEX |    4 ----
> 1 file changed, 4 deletions(-)
>
> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> index 8dfc670..f607367 100644
> --- a/Documentation/00-INDEX
> +++ b/Documentation/00-INDEX
> @@ -328,8 +328,6 @@ sysrq.txt
> 	- info on the magic SysRq key.
> telephony/
> 	- directory with info on telephony (e.g. voice over IP) support.
> -time_interpolators.txt
> -	- info on time interpolators.
> uml/
> 	- directory with information about User Mode Linux.
> unicode.txt
> @@ -346,8 +344,6 @@ vm/
> 	- directory with info on the Linux vm code.
> volatile-considered-harmful.txt
> 	- Why the "volatile" type class should not be used
> -voyager.txt
> -	- guide to running Linux on the Voyager architecture.
> w1/
> 	- directory with documents regarding the 1-wire (w1) subsystem.
> watchdog/
>
