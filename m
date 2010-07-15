Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845Ab0GOWGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:06:45 -0400
Received: from www.tglx.de ([62.245.132.106]:58891 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934480Ab0GOWGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:06:44 -0400
Date: Fri, 16 Jul 2010 00:06:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Make CONFIG_DEBUG_RODATA boot-time configurable
In-Reply-To: <20100715210944.GA24961@redhat.com>
Message-ID: <alpine.LFD.2.00.1007152332030.2673@localhost.localdomain>
References: <20100715210944.GA24961@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Dave Jones wrote:

> We had a request to disable DEBUG_RODATA in our kernel for debugging purposes.  
> Turning it off completely seems a bit unfortunate for the minority case
> of people wanting to do debugging, so I came up with this patch to make
> it a boot-time 'disable_rodata' argument.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
 
Nice one, shouldn't we get rid of the DEBUG_RODATA config and enable
it unconditionally ?

Thanks,

	tglx
