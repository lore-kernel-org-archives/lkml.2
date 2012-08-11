Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab2HKR1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 13:27:08 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44400 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507Ab2HKR1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 13:27:05 -0400
Date: Sat, 11 Aug 2012 19:26:38 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
Message-ID: <20120811172638.GA9440@kibibi>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de>
 <20120806073811.GA3261@breakpoint.cc>
 <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de>
 <502252C8.3090600@linutronix.de>
 <20120808120737.GA5433@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120808120737.GA5433@avionic-0098.mockup.avionic-design.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding | 2012-08-08 14:07:37 [+0200]:

>With that in place, the driver code can match on "intel,hpet" to catch
>all implementations and use the more specific entries if quirks are
>required for the specific hardware.

from http://lkml.org/lkml/2011/2/16/350:

|"intel,ioapic" is probably too generic and can be dropped.  Newer
|devices can claim compatibility with "intel,ioapic-ce4100" if they are
|indeed compatible so that device drivers don't need to be modified.
|It is better to anchor compatible values to real implementations that
|try to come up with 'generic' or wildcard strings.  Ditto through the
|rest of the file.

>Thierry

Sebastian
