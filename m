Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0EPWxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:53:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:44681 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0EPWxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:53:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,243,1272870000"; 
   d="scan'208";a="518399996"
Date: Mon, 17 May 2010 00:53:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       Linus Walleij <linus.walleij@stericsson.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: new AB8500 driver
Message-ID: <20100516225355.GF3236@sortiz.org>
References: <1273553131-9312-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273553131-9312-1-git-send-email-rabin.vincent@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Tue, May 11, 2010 at 10:15:31AM +0530, Rabin Vincent wrote:
> Add a new driver to support the AB8500 Power Management chip, replacing
> the current AB4500.  The new driver replaces the old one, instead of an
> incremental modification, because this is a substantial overhaul
> including:
> 
>  - Split of the driver into -core and -spi portions, to allow another
>    interface layer to be added
> 
>  - Addition of interrupt support
> 
>  - Switch to MFD core API for handling subdevices
> 
>  - Simplification of the APIs to remove a redundant block parameter
> 
>  - Rename of the APIs and macros from ab4500_* to ab8500_*
> 
>  - Rename of the files from ab4500* to ab8500*
> 
> The driver still identifes itself as "ab4500" 
The patch looks good, but why not changing that to "ab8500" and integrating
the relevant board file changes to this patch ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
