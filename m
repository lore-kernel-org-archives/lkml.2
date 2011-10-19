Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1JSAbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:31:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34621 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751043Ab1JSAbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:31:41 -0400
Message-ID: <1318984301.7569.9.camel@Joe-Laptop>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
From: Joe Perches <joe@perches.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Date: Tue, 18 Oct 2011 17:31:41 -0700
In-Reply-To: <4E9E1944.80601@am.sony.com>
References: <4E9E0B71.9020708@am.sony.com>
	 <1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 17:26 -0700, Tim Bird wrote:
> On 10/18/2011 05:14 PM, Joe Perches wrote:
> > On Tue, 2011-10-18 at 16:27 -0700, Tim Bird wrote:
> >> I'm about to submit a set of patches (really pretty small)
> >> to add 4K stack support to ARM (defaulted to 'N').
> > When 4k stacks went away, I thought it safe enough
> > to submit vsnprintf recursion using %pV.
> Even inside Sony, usage of 4K stacks is limited
> to some very special cases, where memory is exceedingly
> tight (we have one system with 4M of RAM).  And we
> don't mind lopping off features or coding around
> problem areas to support our special case.

I believe CONFIG_PRINTK=n assures no %pV problem.

