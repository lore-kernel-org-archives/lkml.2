Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2IJH22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:28:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41043
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab2IJH2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:28:24 -0400
Date: Mon, 10 Sep 2012 03:28:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        nab@linux-iscsi.org, hch@lst.de, roland@kernel.org
Subject: Re: [PATCH 00/11] lots of fixes for zero allocation length
Message-ID: <20120910072820.GA26052@infradead.org>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 05:30:31PM +0200, Paolo Bonzini wrote:
> Here are the fixes for zero-length commands, that ultimately let
> all command go through normal processing, even if they have
> zero length.
> 
> The first patch is for PSCSI, the others are for IBLOCK and friends.
> I tried to order them so that the safest come first.  So for 3.6 you
> could choose to stop at patch 1, 2, 3 or 6, or not apply anything
> at all.
> 
> Testcases included in each patch, when relevant.

Can you please submit them for the scsi testsuite?

