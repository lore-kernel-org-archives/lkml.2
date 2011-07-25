Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1GYTSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:18:03 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42707 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1GYTSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:18:01 -0400
Date: Mon, 25 Jul 2011 12:17:47 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        nico@fluxnic.net, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/6] microblaze: move pci flag functions into asm-generic
Message-ID: <20110725191747.GA14274@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
 <1309366019-24379-2-git-send-email-robherring2@gmail.com>
 <20110629095436.154cff94@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629095436.154cff94@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 09:54:36AM -0700, Jesse Barnes wrote:
> On Wed, 29 Jun 2011 11:46:54 -0500
> Rob Herring <robherring2@gmail.com> wrote:
> 
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > Move pci_set_flags, pci_add_flags, and pci_has_flag into
> > asm-generic/pci-bridge.h so other archs can use them.
> 
> Looks like something Ram may be able to re-use when adding resource
> alloc behavior flags for the new bridge realloc code.
> 
Hmm..these functions modify the global pci_flags variable.  If there
were macros that helped check/set/reset for flags in a given variable,
I could use them.

RP
