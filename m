Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2AYPnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:43:05 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53668
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347Ab2AYPnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:43:04 -0500
Date: Wed, 25 Jan 2012 10:43:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
 the staging area
Message-ID: <20120125154300.GA19509@infradead.org>
References: <1326402943-14031-1-git-send-email-kys@microsoft.com>
 <20120114164228.GB9682@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481B6F0307@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20120116152951.GA9720@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481B6FE0E2@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B6FE0E2@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 03:29:05PM +0000, KY Srinivasan wrote:
> James,
> Any updates here? 

Given that this is a new driver without external dependencies it seems
fine even for a 3.3 merge to me.

