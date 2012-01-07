Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984Ab2AGVKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 16:10:11 -0500
Received: from mail4.comsite.net ([205.238.176.238]:1816 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2AGVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 16:10:10 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH]Kconfig:acpi Fix typo in comment.
Date: Sat, 07 Jan 2012 15:10:08 -0600
X-Originating-IP: 71.22.127.106
Message-ID: <1325970608_1267@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012 about 08:49:48 -0800, "Justin P. Mattock" wrote:

> The below fixes a typo I found in a comment.

Except its not in a comment that only programmers read, but in the help
text of a config entry, and so would be eligible for stable.

> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -374,7 +374,7 @@ config ACPI_CUSTOM_METHOD
>  	depends on DEBUG_FS
>  	default n
>  	help
> -	  This debug facility allows ACPI AML methods to me inserted and/or
> +	  This debug facility allows ACPI AML methods to be inserted and/or
>  	  replaced without rebooting the system. For details refer to:
>  	  Documentation/acpi/method-customizing.txt.
>  

milton
