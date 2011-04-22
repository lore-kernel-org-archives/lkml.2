Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1DVP0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:26:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:36732 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab1DVP0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:26:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,254,1301900400"; 
   d="scan'208";a="737075510"
Date: Fri, 22 Apr 2011 08:25:20 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk, shaohua.li@intel.com,
        sds@tycho.nsa.gov, jmorris@namei.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/3] SECURITY: Move exec_permission RCU checks into
 security modules
Message-ID: <20110422152520.GB10755@tassilo.jf.intel.com>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
 <1303431801-10540-2-git-send-email-andi@firstfloor.org>
 <20110422043444.GA9038@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422043444.GA9038@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems to miss the hunk in fs/namei.c where the LSM hook is called.

namei.c doesn't need changes because it already passes in the flags
The changed semantics only "start" in security/security.c

Thanks for review.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
