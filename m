Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2ADWUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:20:22 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:36504 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757147Ab2ADWUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:20:20 -0500
Message-ID: <4F04DE5B.4070106@xenotime.net>
Date: Wed, 04 Jan 2012 15:18:51 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Add explanation for two missing bits in
 the tainted flag
References: <4eeb4a03.gOyP8gudQ1A+Jo2u%Larry.Finger@lwfinger.net>
In-Reply-To: <4eeb4a03.gOyP8gudQ1A+Jo2u%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 05:39 AM, Larry Finger wrote:
> Two of the bits in the tainted flag are not documented.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing-new/Documentation/sysctl/kernel.txt
> ===================================================================
> --- wireless-testing-new.orig/Documentation/sysctl/kernel.txt
> +++ wireless-testing-new/Documentation/sysctl/kernel.txt
> @@ -579,6 +579,8 @@ can be ORed together:
>          instead of using the one provided by the hardware.
>   512 - A kernel warning has occurred.
>  1024 - A module from drivers/staging was loaded.
> +2048 - The system is working around a severe firmware bug.
> +4096 - An out-of-tree module has been loaded.
>  
>  ==============================================================
>  

Applied, thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
