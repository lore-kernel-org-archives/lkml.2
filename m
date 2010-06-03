Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab0FCHGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:06:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab0FCHGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:06:10 -0400
Date: Thu, 3 Jun 2010 03:06:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 4/5] BKL: use no BKL in llseek
Message-ID: <20100603070608.GA12123@infradead.org>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de> <1275523999-27462-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275523999-27462-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:13:18AM +0200, Arnd Bergmann wrote:
> We have shown that the BKL in default_llseek and other
> llseek operations never protects against concurrent access
> from another function:

>From VFS POV no to the default_llseek conversion.  As told you and
others of the BKL brigade don't change this thing but get rid of it
entirely.  I was under the impression we had agreed on a road map
for that anyway.  Please don't forget that overall kernel improvement
should at least be a side effect of your big sweap and clean.

