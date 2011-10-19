Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1JSFCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:02:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44999 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab1JSFCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:02:15 -0400
Date: Wed, 19 Oct 2011 07:02:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Joe Perches <joe@perches.com>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
Message-ID: <20111019050211.GF15908@one.firstfloor.org>
References: <4E9E0B71.9020708@am.sony.com> <1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com> <20111019045418.GF21338@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019045418.GF21338@dastard>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "You can't use block based storage because the storage stack doesn't
> fit in 4k."

Likely far more than that.

Perhaps a better way would be to simply put the stack into a virtual
mapping and allocate more as needed.

I agree it's a bad idea in mainline.

-Andi
