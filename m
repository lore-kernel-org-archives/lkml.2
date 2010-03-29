Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0C2Ss7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:48:59 -0400
Received: from ns.penguin.cz ([84.21.108.25]:35143 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0C2Ss5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:48:57 -0400
Subject: Re: bit errors on spitz
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andy Green <andy@warmcat.com>, Eric Miao <eric.y.miao@gmail.com>,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       thommycheck@gmail.com, zaurus-devel@www.linuxtogo.org,
       omegamoon@gmail.com
In-Reply-To: <20100329182736.GA1373@ucw.cz>
References: <20100305212708.GC21773@elf.ucw.cz>
	 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
	 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
	 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
	 <4B98EF5D.5000609@warmcat.com> <1268322155.3990.114.camel@hammer.suse.cz>
	 <4B995EE1.1050609@warmcat.com> <1268384824.4963.35.camel@utx.utx.cz>
	 <20100321204335.GM1933@elf.ucw.cz> <1269207753.13196.53.camel@utx.utx.cz>
	 <20100329182736.GA1373@ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Mon, 29 Mar 2010 20:52:08 +0200
Message-ID: <1269888728.3972.73.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> > Alternatively, it is possible to write a driver. It is just one byte
> > write and one byte read via I2C.
> 
> Do you know what byte it is? That sounds easy enough...

Yes, it should be easy driver. One byte address and then one byte write
or one byte read.

See the datasheet:
http://www.penguin.cz/~utx/zaurus/datasheets/power/XScale/ISL6271A.pdf

Page 11: address
Pages 8 and 9: Data interpretation

-- 
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

