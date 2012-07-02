Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2GBN5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:57:51 -0400
Received: from tundra.namei.org ([65.99.196.166]:49371 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2GBN5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:57:50 -0400
Date: Mon, 2 Jul 2012 23:57:43 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Paul Mundt <lethal@linux-sh.org>
cc: James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security: Fix nommu build.
In-Reply-To: <20120702053408.GA24230@linux-sh.org>
Message-ID: <alpine.LRH.2.02.1207022357280.25195@tundra.namei.org>
References: <20120702053408.GA24230@linux-sh.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012, Paul Mundt wrote:

> The security + nommu configuration presently blows up with an undefined
> reference to BDI_CAP_EXEC_MAP:
> 
> security/security.c: In function 'mmap_prot':
> security/security.c:687:36: error: dereferencing pointer to incomplete type
> security/security.c:688:16: error: 'BDI_CAP_EXEC_MAP' undeclared (first use in this function)
> security/security.c:688:16: note: each undeclared identifier is reported only once for each function it appears in
> 
> include backing-dev.h directly to fix it up.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
