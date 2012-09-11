Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab2IKOng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:43:36 -0400
Received: from smtp-out-025.synserver.de ([212.40.185.25]:1051 "EHLO
	smtp-out-024.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759170Ab2IKOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:43:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21051
Message-ID: <504F4E36.20309@metafoo.de>
Date: Tue, 11 Sep 2012 16:44:06 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, Greg Ungerer <gerg@uclinux.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Make the managed clk functions generically available
References: <1347202862-1617-1-git-send-email-lars@metafoo.de> <20120909235059.GA2643@sirena.org.uk> <20120910001524.GL13739@n2100.arm.linux.org.uk> <20120910002020.GB16249@opensource.wolfsonmicro.com> <20120910003913.GM13739@n2100.arm.linux.org.uk>
In-Reply-To: <20120910003913.GM13739@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 02:39 AM, Russell King - ARM Linux wrote:
> On Mon, Sep 10, 2012 at 08:20:21AM +0800, Mark Brown wrote:
>>[...]
>> OK, that's what I'd thought was going on - it was the fact that you'd
>> just acked the patch rather than asked for it to go to the patch tracker
>> or something which made me wonder if things had changed.
> 
> I kind'a forgot because it's been soo long since I took any of those
> patches...

Ok, what's the plan? Should I add this patch to the patch tracker?

Thanks,
- Lars
