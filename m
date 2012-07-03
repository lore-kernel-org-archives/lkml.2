Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2GCH1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:27:34 -0400
Received: from linux-sh.org ([111.68.239.195]:56642 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2GCH1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:27:32 -0400
Date: Tue, 3 Jul 2012 16:27:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: James Morris <jmorris@namei.org>
Cc: James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security: Fix nommu build.
Message-ID: <20120703072722.GA15679@linux-sh.org>
References: <20120702053408.GA24230@linux-sh.org>
 <alpine.LRH.2.02.1207022357280.25195@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1207022357280.25195@tundra.namei.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 11:57:43PM +1000, James Morris wrote:
> On Mon, 2 Jul 2012, Paul Mundt wrote:
> 
> > The security + nommu configuration presently blows up with an undefined
> > reference to BDI_CAP_EXEC_MAP:
> > 
> > security/security.c: In function 'mmap_prot':
> > security/security.c:687:36: error: dereferencing pointer to incomplete type
> > security/security.c:688:16: error: 'BDI_CAP_EXEC_MAP' undeclared (first use in this function)
> > security/security.c:688:16: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > include backing-dev.h directly to fix it up.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next
> 
I'm not sure how you're managing your trees, but this is needed for
Linus's tree.
