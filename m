Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0G0GIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 02:08:42 -0400
Received: from claw.goop.org ([74.207.240.146]:53483 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0G0GIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 02:08:40 -0400
Message-ID: <4C4E77E6.3040007@goop.org>
Date: Mon, 26 Jul 2010 23:08:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: manual merge of the xen tree with Linus' tree
References: <20100727133207.9b6846fe.sfr@canb.auug.org.au>
In-Reply-To: <20100727133207.9b6846fe.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/26/2010 08:32 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the xen tree got a conflict in
> arch/x86/kernel/hpet.c between commit
> ff4878089e1eaeac79d57878ad4ea32910fb4037 ("x86: Do not try to disable
> hpet if it hasn't been initialized before") from Linus' tree and commit
> ef7612e63eafaa6101f5d3185ed8d9bf232ba627 ("x86: Do not try to disable
> hpet if it hasn't been initialized before") from the xen tree.
>
> Two versions of the same patch.  I used the version from Linus' tree
> since it was dated later and had been modified by Thomas.

Thanks, I was waiting for that to land.  I'll drop it from my branch.

     J

