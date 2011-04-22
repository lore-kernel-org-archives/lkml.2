Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1DVP1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:27:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1DVP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:27:49 -0400
Date: Fri, 22 Apr 2011 11:27:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk, shaohua.li@intel.com, sds@tycho.nsa.gov,
        jmorris@namei.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/3] SECURITY: Move exec_permission RCU checks into
 security modules
Message-ID: <20110422152745.GB30519@infradead.org>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
 <1303431801-10540-2-git-send-email-andi@firstfloor.org>
 <20110422043444.GA9038@infradead.org>
 <20110422152520.GB10755@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422152520.GB10755@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 08:25:20AM -0700, Andi Kleen wrote:
> > This seems to miss the hunk in fs/namei.c where the LSM hook is called.
> 
> namei.c doesn't need changes because it already passes in the flags
> The changed semantics only "start" in security/security.c

You're right, sorry.

