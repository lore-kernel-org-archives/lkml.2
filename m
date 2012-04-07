Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2DGBEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:04:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50845 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab2DGBEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:04:50 -0400
Message-ID: <4F7F92AA.2050506@landley.net>
Date: Fri, 06 Apr 2012 20:04:42 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] Documentaion: Fix multiple typo in Documentation
References: <1333727104-10181-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1333727104-10181-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 10:45 AM, Masanari Iida wrote:
> Correct multiple spelling typo in Documentation.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
...
> diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
> index d40d2b5..25e9428 100644
> --- a/Documentation/ABI/testing/sysfs-ptp
> +++ b/Documentation/ABI/testing/sysfs-ptp
> @@ -50,7 +50,7 @@ Description:
>  		This file contains the number of programmable periodic
>  		output channels offered by the PTP hardware clock.
>  
> -What:		/sys/class/ptp/ptpN/pps_avaiable
> +What:		/sys/class/ptp/ptpN/pps_available

Checked to make sure the _code_ isn't actually using "avaiable" here.
It isn't.  (Rather a lot of hits for that typo, though...)

>  i.	New template defined to represent each family of controllers (identified by processor used). 
> -	The template will have defintions that will be initialised to appropritae values for a specific family of controllers. The template definition has four function pointers. During driver initialisation the function pointers will be set based on the controller family type. This change is done to support new controllers that has different processors and thus different register set.
> +	The template will have defintions that will be initialised to appropriate values for a specific family of controllers. The template definition has four function pointers. During driver initialisation the function pointers will be set based on the controller family type. This change is done to support new controllers that has different processors and thus different register set.

defintions still isn't right, but at least no worse.

Looks good, I'll add it to my queue if trivial doesn't pick it up first.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
