Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab1D0PTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:19:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55110 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab1D0PTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:19:19 -0400
Date: Wed, 27 Apr 2011 08:19:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 8/8] staging/mei: Updates to staging/Kconfig ane
 staging/Makefile and a new Makefile and Kconfig
Message-Id: <20110427081901.d78d05ea.randy.dunlap@oracle.com>
In-Reply-To: <1303900057-21694-9-git-send-email-oren.jer.weil@intel.com>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
	<1303900057-21694-9-git-send-email-oren.jer.weil@intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DB833ED.00CC:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 13:27:37 +0300 Oren Weil wrote:


> diff --git a/drivers/staging/mei/Kconfig b/drivers/staging/mei/Kconfig
> new file mode 100644
> index 0000000..5beb2b1
> --- /dev/null
> +++ b/drivers/staging/mei/Kconfig
> @@ -0,0 +1,10 @@
> +config INTEL_MEI
> +	tristate "Intel Management Engine Interface (Intel MEI)"
> +	depends on X86 && EXPERIMENTAL
> +	help
> +		The Intel Management Engine (Intel ME) provides Manageability,
> +		Security and Media services for system containing Intel chipsets.

		                                systems

> +		if selected /dev/mei misc device will be created.

		If selected,

> +
> +		For more information see
> +		<http://software.intel.com/en-us/manageability/>

help text should be indented with 1 tab + 2 spaces (Chapter 10 of CodingStyle).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
