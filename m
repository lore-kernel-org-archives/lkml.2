Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1ANKIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:08:52 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53480 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756806Ab1ANKIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:08:45 -0500
X-Sasl-enc: Y0Os0zthCeXEj81CEVYihyMWXgXBwuwiMKpja6nKmEJ6 1294999724
Message-ID: <4D302081.3020102@fastmail.fm>
Date: Fri, 14 Jan 2011 10:08:01 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-kernel@vger.kernel.org, linux@simtec.co.uk,
        Vincent Sanders <vince@simtec.co.uk>,
        Simtec Support <support@simtec.co.uk>
Subject: Re: [PATCH 3/3] MAINTAINERS: Fixup Simtec support email entries
References: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org> <fd0227dd223f5c88e559b2902d5124107ffb7c6a.1294998254.git.ben-linux@fluff.org>
In-Reply-To: <fd0227dd223f5c88e559b2902d5124107ffb7c6a.1294998254.git.ben-linux@fluff.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/2011 09:44, Ben Dooks wrote:
> The support@simtec.co.uk address is for direct customer support only, the
> EB2410ITX and EB110ATX entries should direct to the Simtec Linux Team
> address of linux@simtec.co.uk
> 
> Also add correct email address for Vincent Sanders
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> Cc: Vincent Sanders <vince@simtec.co.uk>
> Cc: Simtec Support <support@simtec.co.uk>
> Cc: Simtec Linux Team <linux@simtec.co.uk>
> ---
>  MAINTAINERS |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4a99ddf..3f5dc25 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5557,13 +5557,15 @@ F:	include/linux/sfi*.h
>  
>  SIMTEC EB110ATX (Chalice CATS)
>  P:	Ben Dooks
> -M:	Vincent Sanders <support@simtec.co.uk>
> +P:	Vincent Sanders <support@simtec.co.uk>

Did you mean to update this email as well?

Thanks,

Jack
