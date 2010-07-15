Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854Ab0GOWKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934528Ab0GOWKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:10:14 -0400
Date: Thu, 15 Jul 2010 18:09:56 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Make CONFIG_DEBUG_RODATA boot-time configurable
Message-ID: <20100715220956.GC19664@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	Arjan van de Ven <arjan@infradead.org>
References: <20100715210944.GA24961@redhat.com>
 <alpine.LFD.2.00.1007152332030.2673@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1007152332030.2673@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 12:06:16AM +0200, Thomas Gleixner wrote:
 > On Thu, 15 Jul 2010, Dave Jones wrote:
 > 
 > > We had a request to disable DEBUG_RODATA in our kernel for debugging purposes.  
 > > Turning it off completely seems a bit unfortunate for the minority case
 > > of people wanting to do debugging, so I came up with this patch to make
 > > it a boot-time 'disable_rodata' argument.
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 >  
 > Nice one, shouldn't we get rid of the DEBUG_RODATA config and enable
 > it unconditionally ?

I personally have no objection, but others might.
follow-up patch rather than including it in this maybe?

	Dave

