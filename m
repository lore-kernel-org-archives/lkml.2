Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1LBPYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:24:08 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37642 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1LBPYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:24:07 -0500
Date: Fri, 2 Dec 2011 16:24:03 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
Message-ID: <20111202152403.GB16690@gere.osrc.amd.com>
References: <4ED8E2270200007800065120@nat28.tlf.novell.com>
 <20111202143517.GA16690@gere.osrc.amd.com>
 <4ED8F46E0200007800065178@nat28.tlf.novell.com>
 <4ED8EB7D.5070802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED8EB7D.5070802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 08:45:09PM +0530, Srivatsa S. Bhat wrote:
> Your patch fixes the issue more properly than mine, but adding your part
> on top of my patch makes the code look better. For example,
> platform_device_unregister() wouldn't need to be called twice; and we 
> can use the quite popular way of handling error path via goto statements,
> which makes the code flow much more comprehensible and intuitive.

Yes,

goto labels is the proper way for spelling error handling in the kernel
so I could very well take your patch Jan, instead, if you change it to
use goto labels for the error path as Srivatsa's patch does it. That is,
in case Ingo hasn't pulled yet.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
