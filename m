Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0DHIXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:23:30 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37510 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0DHIX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:23:26 -0400
Date: Thu, 8 Apr 2010 10:23:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marc Zyngier <maz@misterjones.org>, Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] set max63xx driver as ARM only
Message-ID: <20100408102305.4bbddbe0@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <v2t10f740e81004071056w26ed1b84i1e4af6a7747b70e3@mail.gmail.com>
References: <201004062159.o36Lx320032351@hera.kernel.org>
	<v2t10f740e81004071056w26ed1b84i1e4af6a7747b70e3@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010 19:56:18 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > +config MAX63XX_WATCHDOG
> > +       tristate "Max63xx watchdog"
> > +       depends on ARM  
> 
> Shouldn't that have been `depends on HAS_IOMEM' instead?

Using HAS_IOMEM will prevent the build of the driver on s390 and is
imho the correct dependency.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

