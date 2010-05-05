Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab0EEWUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:20:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34687 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868Ab0EEWUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:20:04 -0400
Date: Wed, 5 May 2010 15:25:53 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       x86@kernel.org, linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
Message-ID: <20100505222553.GA6555@us.ibm.com>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu> <1272723382-19470-12-git-send-email-orenl@cs.columbia.edu> <20100505141447.fc2397f6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505141447.fc2397f6.randy.dunlap@oracle.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap [randy.dunlap@oracle.com] wrote:
| > +		base of the region allocated for stack. These architectures
| > +		must pass in the size of the stack-region in ->child_stack_size.
| 
| 		                             stack region
| 
| Seems unfortunate that different architectures use the fields differently.

Yes and no. The field still has a single purpose, just that some architectures
may not need it. We enforce that if unused on an architecture, the field must
be 0. It looked like the easiest way to keep the API common across
architectures.

| 
| Is this example program meant to build only on i386?

Yes. Will add a pointer to the clone*.[chS] and libeclone.a files in

	git://git.ncl.cs.columbia.edu/pub/git/user-cr.git

for other architectures (currently x86_64, ppc, s390).

Thanks for the review. Will fix the errors and repost.

Sukadev
