Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1KHIcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:32:47 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:43394 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1KHIcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:32:46 -0500
X-IronPort-AV: E=Sophos;i="4.69,476,1315180800"; 
   d="scan'208";a="8808951"
Subject: Re: 2.6.32.47 breaks UML build (both i386 and amd64)
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Antoine Martin <antoine@nagafix.co.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4EB8CBB0.8010201@nagafix.co.uk>
References: <4EB8CBB0.8010201@nagafix.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Tue, 8 Nov 2011 08:32:44 +0000
Message-ID: <1320741164.16747.63.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 13:26 +0700, Antoine Martin wrote:
> (...)
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `sysdev_resume':
> /linux-2.6.32.47-amd64/drivers/base/sys.c:478: undefined reference to
> `irq_pm_syscore_resume'
> collect2: ld returned 1 exit status
>   KSYM    .tmp_kallsyms1.S
> nm: '.tmp_vmlinux1': No such file
> No valid symbol.
> make: *** [.tmp_kallsyms1.S] Error 1

Thanks, I posted a fix already in
<1320736973.16747.55.camel@dagon.hellion.org.uk>

Ian.


