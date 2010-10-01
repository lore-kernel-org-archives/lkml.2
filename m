Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0JANLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:11:46 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:50996 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0JANLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:11:44 -0400
Date: Fri, 1 Oct 2010 23:12:01 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH v5]update broken web addresses in the kernel.
In-Reply-To: <1285854709-7488-2-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.OSX.2.00.1010012250340.382@localhost>
References: <1285854709-7488-1-git-send-email-justinmattock@gmail.com> <1285854709-7488-2-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Sep 2010, Justin P. Mattock wrote:

> diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
> index bf0862a..897702d 100644
> --- a/drivers/hwmon/hwmon-vid.c
> +++ b/drivers/hwmon/hwmon-vid.c
> @@ -38,7 +38,7 @@
>   * available at http://developer.intel.com/.
>   *
>   * AMD Athlon 64 and AMD Opteron Processors, AMD Publication 26094,
> - * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26094.PDF
> + * http://developer.amd.com/documentation/articles/pages/1212200690_2.aspx 

That pdf has moved this URL:
http://support.amd.com/us/Processor_TechDocs/26094.PDF


>   * Table 74. VID Code Voltages
>   * This corresponds to an arbitrary VRM code of 24 in the functions below.
>   * These CPU models (K8 revision <= E) have 5 VID pins. See also:

Regards,
Finn
