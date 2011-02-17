Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1BQBrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:47:37 -0500
Received: from tundra.namei.org ([65.99.196.166]:52123 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1BQBrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:47:35 -0500
Date: Thu, 17 Feb 2011 12:46:29 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
        eparis@redhat.com, viro@zeniv.linux.org.uk,
        Dave Chinner <david@fromorbit.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode
 citizen
In-Reply-To: <1297897693.2524.201.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1102171245550.6509@tundra.namei.org>
References: <1297715397-4141-1-git-send-email-zohar@linux.vnet.ibm.com> <1297897693.2524.201.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011, Mimi Zohar wrote:

> Hi, 
> 
> As Linus has already agreed that the i_readcount patches (1 - 4) can be
> upstreamed (https://lkml.org/lkml/2010/11/18/670), do I need to do
> anything else (eg. send James a request to pull)?


I've pulled these changes into
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
