Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0HBNab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:30:31 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60805 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0HBNa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:30:29 -0400
Date: Mon, 2 Aug 2010 14:30:08 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        mingo@elte.hu, linux-mips@linux-mips.org
Subject: Re: [PATCH 05/15] mips,kgdb: Individual register get/set for mips
Message-ID: <20100802133008.GB5209@linux-mips.org>
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
 <1280517456-1167-6-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280517456-1167-6-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 02:17:26PM -0500, Jason Wessel wrote:

> Implement the ability to individually get and set registers for kdb
> and kgdb for mips.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> CC: Ralf Baechle <ralf@linux-mips.org>
> CC: linux-mips@linux-mips.org

Looks good; I think this should be be merged with the rest of your stuff.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
