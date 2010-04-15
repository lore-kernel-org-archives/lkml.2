Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0DOF65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:58:57 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:39333 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755114Ab0DOF6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:58:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAJIxktbstG6/2dsb2JhbACbYHK+PQ2FAQQ
Date: Thu, 15 Apr 2010 07:58:53 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marc Zyngier <maz@misterjones.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] set max63xx driver as ARM only
Message-ID: <20100415055853.GE15728@infomag.iguana.be>
References: <201004062159.o36Lx320032351@hera.kernel.org> <v2t10f740e81004071056w26ed1b84i1e4af6a7747b70e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <v2t10f740e81004071056w26ed1b84i1e4af6a7747b70e3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert, Martin,

> > +config MAX63XX_WATCHDOG
> > +       tristate "Max63xx watchdog"
> > +       depends on ARM
> 
> Shouldn't that have been `depends on HAS_IOMEM' instead?

Correct. Will add this today or tomorrow.

Kind regards,
Wim.

