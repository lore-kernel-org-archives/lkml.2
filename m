Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935586Ab0GPDtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:49:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:50641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935223Ab0GPDtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:49:04 -0400
Date: Thu, 15 Jul 2010 20:53:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: Make CONFIG_DEBUG_RODATA boot-time configurable
Message-ID: <20100715205304.7a53aa02@infradead.org>
In-Reply-To: <alpine.LFD.2.00.1007152332030.2673@localhost.localdomain>
References: <20100715210944.GA24961@redhat.com>
	<alpine.LFD.2.00.1007152332030.2673@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 00:06:16 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 15 Jul 2010, Dave Jones wrote:
> 
> > We had a request to disable DEBUG_RODATA in our kernel for
> > debugging purposes. Turning it off completely seems a bit
> > unfortunate for the minority case of people wanting to do
> > debugging, so I came up with this patch to make it a boot-time
> > 'disable_rodata' argument.
> > 
> > Signed-off-by: Dave Jones <davej@redhat.com>
>  
> Nice one, shouldn't we get rid of the DEBUG_RODATA config and enable
> it unconditionally ?
> 

I'd go one step further; enable unconditional, and have the config
option control if you can turn it off or not...
