Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0JSQ3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:29:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab0JSQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:29:20 -0400
Date: Tue, 19 Oct 2010 12:29:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, zohar@us.ibm.com, warthog9@kernel.org,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101019162907.GA5785@infradead.org>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <20101019013037.GA31393@infradead.org>
 <1287454443.2530.124.camel@localhost.localdomain>
 <20101019073901.GB11284@dastard>
 <1287505483.2530.174.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287505483.2530.174.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

I think you and just about everyone here are on a different page, and
before we have the basic disagreement settled I'm not sure we can
make much progress.

Can you please explain why a feature like IMA that no sane user would
ever want should cause _any_ overhead for users that just have it
compiled in because their distro or defconfig did without actually
using.

What exactly is the problem to require the few people that want it to
use a kernel command line option and/or an _DEFAULT_ON config option?

