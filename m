Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab2CETD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:03:57 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47209 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab2CETD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:03:56 -0500
MIME-Version: 1.0
Message-ID: <e64cd1fe-2fcc-4cab-a437-84b2c2939b6d@default>
Date: Mon, 5 Mar 2012 11:02:46 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] staging: zcache: make zcache builtin only
References: <<1330965998-12116-1-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1330965998-12116-1-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F550E15.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Monday, March 05, 2012 9:47 AM
> To: Greg Kroah-Hartman
> Cc: Seth Jennings; Dan Magenheimer; Thadeu Lima de Souza Cascardo; Konrad Rzeszutek Wilk; Nitin Gupta;
> Robert Jennings; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] staging: zcache: make zcache builtin only
> 
> zcache cannot currently be loaded as a module.  However
> the Kconfig allows it to be built as a module; something that
> the user probably does not intend since the module is not
> loadable.
> 
> This patch switches zcache from a tristate to a bool in the Kconfig
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> ---
>  drivers/staging/zcache/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
> index 5a36fcf..3ed2c8f 100644
> --- a/drivers/staging/zcache/Kconfig
> +++ b/drivers/staging/zcache/Kconfig
> @@ -1,5 +1,5 @@
>  config ZCACHE
> -	tristate "Dynamic compression of swap pages and clean pagecache pages"
> +	bool "Dynamic compression of swap pages and clean pagecache pages"
>  	# X86 dependency is because zsmalloc uses non-portable pte/tlb
>  	# functions
>  	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO && X86
> --
> 1.7.5.4
