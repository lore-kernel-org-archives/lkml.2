Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0JaSAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 14:00:24 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:42736 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab0JaSAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 14:00:15 -0400
Date: Sun, 31 Oct 2010 18:00:06 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Joerg Reuter <jreuter@yaina.de>,
        "David S. Miller" <davem@davemloft.net>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: ax25: fix information leak to userland
Message-ID: <20101031180005.GA26588@linux-mips.org>
References: <1288545022-16393-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288545022-16393-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 08:10:22PM +0300, Vasiliy Kulikov wrote:

> Sometimes ax25_getname() doesn't initialize all members of fsa_digipeater
> field of fsa struct.  This structure is then copied to userland.  It leads to
> leaking of contents of kernel stack memory.  We have to initialize them to zero.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
