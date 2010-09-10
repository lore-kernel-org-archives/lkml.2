Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0IJAt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 20:49:58 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:53796 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab0IJAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 20:49:57 -0400
Date: Fri, 10 Sep 2010 02:49:54 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: unable to fetch the mips tree
Message-ID: <20100910004954.GA8325@linux-mips.org>
References: <20100910102614.61909592.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910102614.61909592.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 10:26:14AM +1000, Stephen Rothwell wrote:

> For the last couple of days, I have been getting the following error when
> trying to fetch mips tree:
> 
> git.linux-mips.org[0: 78.24.191.183]: errno=Connection refused

About 30h, I guess.  That's when the machine was upgraded and rebooted.
Fixed now.  Thanks for leting me know.

  Ralf
