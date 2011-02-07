Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1BGV6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:58:04 -0500
Received: from claw.goop.org ([74.207.240.146]:42962 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab1BGV6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:58:01 -0500
Message-ID: <4D506AE6.6080900@goop.org>
Date: Mon, 07 Feb 2011 13:57:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
References: <20110205200108.921707839@linutronix.de> <4D50641B.2090006@goop.org> <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 01:33 PM, Thomas Gleixner wrote:
> Ok. The irq_chip conversion is mostly mechanical, but I'm really
> concerned about that IRQ_SUSPENDED hackery. It'd be nice if you
> resp. Ian could give that a test ride. That would allow me to cleanup
> stuff in the core code.

Ian notes: "tglx's 4 patch interrupt cleanup series on LKML causes some
oddities on PV migration. Will dig further tomorrow..."

So it looks like there's still something amiss.

    J
