Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1GPSY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 14:24:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38622
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab1GPSY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 14:24:59 -0400
Date: Sat, 16 Jul 2011 14:24:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 020/117] Staging: hv: vmbus: Support the notion of id
 tables in vmbus_match()
Message-ID: <20110716182454.GA19023@infradead.org>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-20-git-send-email-kys@microsoft.com>
 <20110716020250.GA7199@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480817A4C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480817A4C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 12:54:46PM +0000, KY Srinivasan wrote:
> > would be nice to add uuid_{le,be}_is_nil helpers to uuid.h.  I also
> > think simply using a memcpy might be more efficient than the hand-rolled
> > loop.
> Having a helper function would be great. With regards to the efficiency of this loop,
> this is not a performance critical path. If people feel strongly about this, I could 
> change this; perhaps as a separate patch on top of this series; I don't want to send a large
> patch-set like this again.

I'm fine with doing it later.

