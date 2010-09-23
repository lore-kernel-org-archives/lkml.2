Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0IWPvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:51:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0IWPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:51:00 -0400
Date: Thu, 23 Sep 2010 11:50:37 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: matt mooney <mfm@muteddisk.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/20] parisc: change to new flag variable
Message-ID: <20100923155037.GA27175@bombadil.infradead.org>
References: <1285224665-29831-1-git-send-email-mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285224665-29831-1-git-send-email-mfm@muteddisk.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 11:51:05PM -0700, matt mooney wrote:
> Replace EXTRA_CFLAGS with ccflags-y.
> 

Looks reasonable, thanks! Applied.

--Kyle
