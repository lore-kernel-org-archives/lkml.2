Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1ESMbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:31:43 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:39853 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756530Ab1ESMbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:31:42 -0400
Date: Thu, 19 May 2011 13:31:43 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] MIPS: Install handlers for software IRQs
Message-ID: <20110519123143.GC18668@linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
 <953858e54ceec800464756a0521abea1@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <953858e54ceec800464756a0521abea1@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 02:22:33PM -0700, Kevin Cernekee wrote:

> BMIPS4350/4380/5000 CMT/SMT all use SW INT0/INT1 for inter-thread
> signaling.

I had previously ages ago applied this patch but it somehow vapolized
so I just refreshed the patch and queued it for 2.6.41, sorry.

  Ralf
