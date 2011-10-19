Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1JSAOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:14:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50323 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750856Ab1JSAOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:14:09 -0400
Message-ID: <1318983248.7569.5.camel@Joe-Laptop>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
From: Joe Perches <joe@perches.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Date: Tue, 18 Oct 2011 17:14:08 -0700
In-Reply-To: <4E9E0B71.9020708@am.sony.com>
References: <4E9E0B71.9020708@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 16:27 -0700, Tim Bird wrote:
> I'm about to submit a set of patches (really pretty small)
> to add 4K stack support to ARM (defaulted to 'N').

When 4k stacks went away, I thought it safe enough
to submit vsnprintf recursion using %pV.

I believe the current vsnprintf max recursion is 3.
Each recursion uses at least 300 bytes of stack.

That might be some additional issue for 4k stacks.

