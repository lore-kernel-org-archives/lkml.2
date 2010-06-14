Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab0FNM11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:27:27 -0400
Received: from lo.gmane.org ([80.91.229.12]:41139 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab0FNM10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:27:26 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Date: Mon, 14 Jun 2010 14:27:08 +0200
Message-ID: <20100614142708.668d382e@holly>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
	<YPGdyfWGvNK.A.C8B.d9OFMB@chimera>
	<201006131722.44062.s.L-H@gmx.de>
	<alpine.DEB.2.01.1006131103590.3964@bogon.housecafe.de>
	<AANLkTily7ZDG16uE2vSsq8t3mssuATwtHnr8OajX8oga@mail.gmail.com>
	<20100614063948.GA3999@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: r6af93.net.upc.cz
In-Reply-To: <20100614063948.GA3999@x200>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Cc: kernel-testers@vger.kernel.org, linux-media@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 09:39:48 +0300
Alexey Dobriyan <adobriyan@gmail.com>
wrote:

> On Sun, Jun 13, 2010 at 01:57:40PM -0600, Grant Likely wrote:
> > On brief review, they look like completely different issues.  I
> > doubt the second patch will fix the flexcop-pci issue.
> 
> It will, see how name wht slashes propagated by request_irq()

Yes, the latter patch dodges the issue with flexcop driver by simply
skipping the directory creation, but both patches should be applied IMO.
The former to fix the flexcop driver because we can trivially fix it,
the latter to solve problems with any generic bogus firmware.

-- 
Jindrich Makovicka


