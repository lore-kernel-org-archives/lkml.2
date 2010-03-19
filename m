Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0CSVNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:13:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51437 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab0CSVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:13:12 -0400
Date: Fri, 19 Mar 2010 21:12:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>,
       Surbhi Palande <surbhi.palande@canonical.com>,
       dri-devel@lists.sourceforge.net,
       Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, yakui.zhao@intel.com, zhenyuw@linux.intel.com,
       Len Brown <lenb@kernel.org>
Subject: Re: ACPI _LID failures
Message-ID: <20100319211253.GA5401@srcf.ucam.org>
References: <89k83ahv05c@azsmga001.ch.intel.com> <cover.1268680514.git.surbhi.palande@canonical.com> <20100319125320.22d8b25d@jbarnes-piketon> <87iq8sqbih.fsf@pollan.anholt.net> <20100319140503.5ac6e061@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319140503.5ac6e061@jbarnes-piketon>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 02:05:03PM -0700, Jesse Barnes wrote:

> Well, that was the hope.  Len said they've fixed EC bugs in the past
> only to find that several ACPI methods they assumed were broken
> suddenly started working....

The broken Acer was reading from the wrong registers. I think that's 
pretty strong evidence that Windows doesn't depend on lid state, 
unfortunately.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
