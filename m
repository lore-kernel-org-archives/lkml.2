Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0IXQc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:32:26 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:46594 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab0IXQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:32:16 -0400
Date: Fri, 24 Sep 2010 17:32:14 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] MIPS: Add a platform hook for swiotlb setup.
Message-ID: <20100924163214.GA29252@linux-mips.org>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
 <1285281496-24696-9-git-send-email-ddaney@caviumnetworks.com>
 <4C9CCD1B.506@mvista.com>
 <4C9CCE42.3030309@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9CCE42.3030309@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 09:13:54AM -0700, David Daney wrote:

> >>+#ifdef CONFIG_SWIOTLB
> >>+ plat_swiotlb_setup();
> >>+#endif
> >
> >We should avoid #ifdef's in function bodies. Why not defile an empty
> >'inline' in the header above if CONFIG_SWIOTLB is not defined?
> >
> 
> Good idea.  I will wait several days and collect any more feedback
> and generate a new patch set.

I'd also wait for a few more days so interested parties outside of the MIPS
world will have a chance to comment.

  Ralf
