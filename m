Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0JVBMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:12:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0JVBMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:12:52 -0400
Date: Thu, 21 Oct 2010 21:12:47 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PARISC: unwind - optimise linked-list searches for
 modules
Message-ID: <20101022011247.GM8332@bombadil.infradead.org>
References: <1284115679-23928-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284115679-23928-1-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 01:47:59PM +0300, Phil Carmody wrote:
> Having many dozens of modules, the searches down the linked
> list of sections would dominate the lookup time, dwarfing
> any savings from the binary search within the section.
> 
> A simple move-to-front optimisation exploits the commonality
> of the code paths taken, and in simple real-world tests
> on other architectures reduced the number of steps in the
> search to barely more than 1.
> 

Applied, thanks.

--kyle
