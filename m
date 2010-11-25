Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0KYUwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 15:52:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:46512 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab0KYUwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 15:52:42 -0500
Subject: Re: RFC: Mega rename of device tree routines from of_*() to dt_*()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: michael@ellerman.id.au, linux-arch <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        sparclinux@vger.kernel.org
In-Reply-To: <AANLkTim9fPPWO-240dmavng+j=70G8Y4P-+j3Y+OZTL0@mail.gmail.com>
References: <1290607413.12457.44.camel@concordia>
	 <1290692075.689.20.camel@concordia>
	 <AANLkTim9fPPWO-240dmavng+j=70G8Y4P-+j3Y+OZTL0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 07:52:04 +1100
Message-ID: <1290718324.32570.127.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 15:01 +0100, Geert Uytterhoeven wrote:
> 
> I always read it as "for each child-OF-node", so I would rename it to
> "dt_for_each_child_node".

Well, it was meant to be for_child_of_node not _OF_node :-)

Cheers,
Ben.


