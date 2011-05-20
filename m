Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab1ETNWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:22:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55205 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab1ETNWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:22:22 -0400
Date: Fri, 20 May 2011 09:22:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: vmbus driver
Message-ID: <20110520132220.GA23390@infradead.org>
References: <1305842785-30206-1-git-send-email-kys@microsoft.com>
 <20110520122649.GA550@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481FC2AF@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481FC2AF@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 01:12:32PM +0000, KY Srinivasan wrote:
> Well, the util driver that implements a range of other services such as KVP, 
> time synch, heartbeat etc. is also a client of the vmbus driver (perhaps not in the 

The KVP driver is a different module as far as I can see.  But it really
needs a lot of work, as no one should use the ugly connector interface
for new code.  The closest equivalent is gennetlink, but I'd like to
understand what it's actually supposed to do in practice.

