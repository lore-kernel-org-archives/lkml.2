Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0GRIvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 04:51:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab0GRIvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 04:51:42 -0400
Date: Sun, 18 Jul 2010 04:51:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 18/18] xstat: Provide a mechanism to gather extra results
 for [f]xstat() [ver #6]
Message-ID: <20100718085140.GD27794@infradead.org>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
 <20100715021730.5544.68442.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715021730.5544.68442.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned before this is total overkill.  The request/respond flags
together with the buffer size already provide enough ways to extent
the structure in a backwards compatible way if needed.

