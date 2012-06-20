Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2FTQNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:13:14 -0400
Received: from h9.dl5rb.org.uk ([81.2.74.9]:42611 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757108Ab2FTQNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:13:12 -0400
Date: Wed, 20 Jun 2012 17:12:49 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] MIPS: fix bug.h MIPS build regression
Message-ID: <20120620161249.GB29196@linux-mips.org>
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com>
 <20120620152759.2caceb8c.yuasa@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620152759.2caceb8c.yuasa@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 03:27:59PM +0900, Yoichi Yuasa wrote:

> Commit: 3777808873b0c49c5cf27e44c948dfb02675d578 breaks all MIPS builds.

Thanks, fix applied.

  Ralf
