Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab1FTTzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:55:07 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50930
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab1FTTzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:55:04 -0400
Date: Mon, 20 Jun 2011 15:55:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin TerAvest <teravest@google.com>
Cc: vgoyal@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH] cfq: Remove special treatment for metadata rqs.
Message-ID: <20110620195500.GA9696@infradead.org>
References: <1308599559-16839-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308599559-16839-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 12:52:39PM -0700, Justin TerAvest wrote:
> There is no consistency among filesystems from what bios (or requests)
> are marked as being metadata. It's interesting to expose this in traces,
> but we shouldn't schedule the requests differently based on whether or
> not they're marked as being metadata.

Personally I totally agree.  If anyone can demonstrate an effect from
the current hacks we shall add them back with a special REQ_ flag just
for the boost.

