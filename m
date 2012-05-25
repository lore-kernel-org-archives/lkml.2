Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab2EYIGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:06:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33864 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756157Ab2EYIGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:06:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX199OFlqmId9/FyuKBcigfSLq9v9VCRw4AfLH0vmvD
	i4e6Rue9VDWKbo
Message-ID: <1337933172.5415.62.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Date: Fri, 25 May 2012 10:06:12 +0200
In-Reply-To: <1337926109.5415.43.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop>
	 <1337926109.5415.43.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 08:08 +0200, Mike Galbraith wrote:

> That little ondemand gizmo needs a wrap upside the head.

Nope, it needs a medic.  3.0 cores crank up fine.

-Mike

