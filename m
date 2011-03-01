Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1CALHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:07:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1CALHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:07:05 -0500
Date: Tue, 1 Mar 2011 06:07:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Josh Hunt <johunt@akamai.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "sandeen@redhat.com" <sandeen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Message-ID: <20110301110702.GA14336@infradead.org>
References: <1298528501-32176-1-git-send-email-johunt@akamai.com>
 <20110224063749.GV22723@ZenIV.linux.org.uk>
 <20110224112010.GB23042@quack.suse.cz>
 <4D66BD18.2030207@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D66BD18.2030207@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you wire up your testcase with xfstests so we can regression test
for it in the future?

