Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab2CTJ7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:59:30 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:44246 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab2CTJ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:59:28 -0400
Date: Tue, 20 Mar 2012 10:59:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120320095924.GA8377@gmail.com>
References: <20120125134947.GF13655@zod.bos.redhat.com>
 <1327529048.2327.17.camel@sbsiddha-mobl2>
 <20120125231534.GL13655@zod.bos.redhat.com>
 <20120131142621.GA2136@zod.bos.redhat.com>
 <1328083230.3638.2.camel@sbsiddha-mobl2>
 <20120312132448.GA20204@zod.bos.redhat.com>
 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
 <20120319133046.GB13093@zod.bos.redhat.com>
 <20120319193842.GA8123@phenom.dumpdata.com>
 <20120320094048.GC20079@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320094048.GC20079@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

>  2). Make the Xen layer fake out an IOAPIC - so instead of 0xffffff, make sure to
>      clear the three bits that Suresh' patch is testing for (Ewwwww, I don't actually
>      like that - that stinks of a hack).

In what universe would a hardware virtualization layer emulating 
actual hardware behavior be a 'hack'?

Thanks,

	Ingo
