Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0FNPnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:43:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41294 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0FNPnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <20100614063948.GA3999@x200>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera> <YPGdyfWGvNK.A.C8B.d9OFMB@chimera> 
	<201006131722.44062.s.L-H@gmx.de> <alpine.DEB.2.01.1006131103590.3964@bogon.housecafe.de> 
	<AANLkTily7ZDG16uE2vSsq8t3mssuATwtHnr8OajX8oga@mail.gmail.com> 
	<20100614063948.GA3999@x200>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 Jun 2010 09:42:40 -0600
X-Google-Sender-Auth: 2tM7Dr5TuMcTSeY_b5i-kA9vjhs
Message-ID: <AANLkTikukzksZJnp1ETRkiSYQYihhmT8nu9-m5zc0dlM@mail.gmail.com>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Michael Ellerman <michael@ellerman.id.au>, linux-media@vger.kernel.org,
       mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:39 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Sun, Jun 13, 2010 at 01:57:40PM -0600, Grant Likely wrote:
>> On brief review, they look like completely different issues.  I doubt
>> the second patch will fix the flexcop-pci issue.
>
> It will, see how name wht slashes propagated by request_irq()

I think we've crossed wires.  By second patch I mean the patch that
changes OF code.  That change has absolutely no bearing on the
flexcop-pci driver.  The patch to the flexcop-pci driver looks correct
to me, but it is completely unrelated to the OF badness.

g.
