Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab0JTG6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:58:54 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:34553 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758241Ab0JTG6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:58:52 -0400
Date: Wed, 20 Oct 2010 07:58:30 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Dezhong Diao <dediao@cisco.com>
Subject: Re: [PATCH] of/mips: Cleanup some include directives/files.
Message-ID: <20101020065830.GA12565@linux-mips.org>
References: <1287528631-31797-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287528631-31797-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 03:50:31PM -0700, David Daney wrote:

> The __init directives should go on the definitions of things, not the
> declaration, also __init is meaningless for inline functions, so
> remove it from prom.h.  This allows us to get rid of a useless
> #include, but most of the rest of them are useless too, so kill them
> as well.
> 
> If of_i2c.c needs irq definitions, it should include linux/irq.h
> directly, not assume indirect inclusion via asm/prom.h.

Grant, I assume you're going to merge this one.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
