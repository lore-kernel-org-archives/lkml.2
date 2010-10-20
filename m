Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0JTSDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:03:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64465 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0JTSDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:03:36 -0400
Date: Wed, 20 Oct 2010 12:03:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Dezhong Diao <dediao@cisco.com>
Subject: Re: [PATCH] of/mips: Cleanup some include directives/files.
Message-ID: <20101020180332.GO7285@angua.secretlab.ca>
References: <1287528631-31797-1-git-send-email-ddaney@caviumnetworks.com>
 <20101020065830.GA12565@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020065830.GA12565@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 07:58:30AM +0100, Ralf Baechle wrote:
> On Tue, Oct 19, 2010 at 03:50:31PM -0700, David Daney wrote:
> 
> > The __init directives should go on the definitions of things, not the
> > declaration, also __init is meaningless for inline functions, so
> > remove it from prom.h.  This allows us to get rid of a useless
> > #include, but most of the rest of them are useless too, so kill them
> > as well.
> > 
> > If of_i2c.c needs irq definitions, it should include linux/irq.h
> > directly, not assume indirect inclusion via asm/prom.h.
> 
> Grant, I assume you're going to merge this one.
> 
> Acked-by: Ralf Baechle <ralf@linux-mips.org>

Yes, I'll pick it up.  I'm compile testing now.

g.

> 
>   Ralf
