Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab1EBUAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:00:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1EBUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:00:16 -0400
Date: Mon, 2 May 2011 16:00:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Message-ID: <20110502200012.GA21619@infradead.org>
References: <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427121856.GA20633@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD676@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110429164025.GA7698@kroah.com>
 <20110501154041.GB15210@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DF253@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110501160721.GA8195@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DF2A0@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110501205315.GC1017@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DF543@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DF543@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 07:48:38PM +0000, KY Srinivasan wrote:
> By setting up appropriate modprobe rules, this can be addressed.

That assumes libata is a module, which it is not for many popular
distributions.

