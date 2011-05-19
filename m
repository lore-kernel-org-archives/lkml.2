Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1ESMLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:11:17 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51427 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755014Ab1ESMLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:11:13 -0400
Date: Thu, 19 May 2011 13:11:08 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] MIPS: Move FIXADDR_TOP into spaces.h
Message-ID: <20110519121108.GB18668@linux-mips.org>
References: <55645e13fcf442f6641b3eb187cab302@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55645e13fcf442f6641b3eb187cab302@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Memory maps and addressing quirks are normally defined in <spaces.h>.
> There are already three targets that need to override FIXADDR_TOP, and
> others exist.  This will be a cleaner approach than adding lots of
> ifdefs in fixmap.h .

Good cleanup, also queued for 2.6.41.

  Ralf
