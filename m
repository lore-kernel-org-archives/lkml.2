Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0EQKhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:37:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:43455 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab0EQKhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:37:09 -0400
Subject: Re: [PATCH]460EX on-chip SATA driver <Kernel 2.6.33> <
 resubmission >
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stefan Roese <sr@denx.de>
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@mvista.com>,
       Rupjyoti Sarmah <rsarmah@amcc.com>, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <201005171206.47566.sr@denx.de>
References: <201005051757.o45HvPmY005954@amcc.com>
	 <4BED8BF1.5080800@ru.mvista.com> <1273966828.21352.670.camel@pasglop>
	 <201005171206.47566.sr@denx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 20:36:31 +1000
Message-ID: <1274092591.21352.722.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Additionally, the boot wrapper should probably either remove the node or
> > at least use a status property "ok" / "disabled" to represent whether
> > the board is configured for SATA or PCIe x1...
> 
> U-Boot already sets the "status" property of the PCIe or SATA node 
> accordingly. Just let me know if this doesn't work for you.

That's probably enough.

Cheers,
Ben.


