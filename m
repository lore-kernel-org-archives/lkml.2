Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1AUR7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:59:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1AUR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:59:21 -0500
Date: Fri, 21 Jan 2011 12:59:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        Dima Zavin <dmitriyz@google.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110121175915.GA27611@infradead.org>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
 <AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
 <1295571359.9236.53.camel@m0nster>
 <1295574085.4096.6.camel@Joe-Laptop>
 <1295575123.9236.54.camel@m0nster>
 <1295576730.4096.24.camel@Joe-Laptop>
 <1295624801.19880.13.camel@m0nster>
 <20110121094827.41818a55@jbarnes-desktop>
 <1295632569.19880.20.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295632569.19880.20.camel@m0nster>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 09:56:09AM -0800, Daniel Walker wrote:
> I did create these commits. Do you think someone else created the
> commits? There is no commit forwarding happening here.

Creating a commit is easy.  I think for cases like this it's a good
idea to at least write down a "Based on patches from ..." in the
commit message, and preferably also how it relates to their patches.
E.g. dropped android local crap, ported to $FOO kernel ABI, or just
rolled up totally confused local repository history.

