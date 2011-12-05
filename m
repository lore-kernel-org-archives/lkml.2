Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1LENkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:40:10 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:59386 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932278Ab1LENkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:40:05 -0500
Subject: Re: [PATCH v4] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>, "Zhang, Rui" <rui.zhang@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
In-Reply-To: <20111205123217.GF3143@elte.hu>
References: <1321621751-3650-1-git-send-email-matt@console-pimps.org>
	 <20111205123217.GF3143@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 13:40:02 +0000
Message-ID: <1323092402.4838.6.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 13:32 +0100, Ingo Molnar wrote:
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> > Zhang, it'd be good to make sure that this still actually 
> > fixes your problem on CONFIG_X86_32. Also, if anyone has a 
> > Macbook Pro/Macbook Air, please make sure that this patch 
> > doesn't cause your machine to reboot/hang, as those machines 
> > tend to be the ones that this problem.
> 
> Ping - has it been tested on an affected box, can we apply it to 
> the x86 tree?

I've not had any response from Zhang or anyone with a macbook. So as far
as I know, no, this v4 patch hasn't been tested on any of the affected
machines.

Zhang, could you test this patch, please? Or pass it along to someone
else who can do the testing. Thanks.

-- 
Matt Fleming, Intel Open Source Technology Center

