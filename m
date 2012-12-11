Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2LKLOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:14:34 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:43195 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751421Ab2LKLOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:14:33 -0500
Date: Tue, 11 Dec 2012 12:14:28 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: RM9000 / E9000, MSP71xx class processors, SOCs and eval boards
Message-ID: <20121211111427.GA23572@linux-mips.org>
References: <20121206160052.GB32620@linux-mips.org>
 <CACoURw7JTFMzmcRZHmBchcWPC8x5LFFfC1nGH-Xxc8f3KjNE2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACoURw7JTFMzmcRZHmBchcWPC8x5LFFfC1nGH-Xxc8f3KjNE2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 03:28:17PM -0600, Shane McDonald wrote:

> I'm interested in the MSP71xx eval board, although I may be
> the only person in the world who cares.  Specifically, I use the
> msp71xx_defconfig.  3.7-rc8 compiles with gcc-4.6.3
> without requiring any patches.
> 
> I don't know when the last time the RM9000 was compilable,
> but I have no interest in that, nor do I have interest in the
> FPGA or eval board versions of the MSP7120 (no hardware to
> test with).
> 
> I had hoped that someone from PMC-Sierra would respond, but
> maybe they don't care anymore...

Being a crazy tradition set by the Sparc AP1000, I'm happy with a single
user :-)

The Yosemite stuff scores higher on my kill list anyway.  The board
support code was never too great but that's not the issue; the SOC's
network driver which is rotting away in the linux-mips.org git tree as
the last change that can't be merged upstream as it is, stopped even
compiling ages ago and while a superior replacement has been posted,
nobody cared enough to get it into mergeable shape.

Now that 3.7 is finally released, hasta la vista, Yosemite.

  Ralf
