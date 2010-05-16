Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0EPXBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 19:01:46 -0400
Received: from tundra.namei.org ([65.99.196.166]:56657 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab0EPXBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 19:01:44 -0400
Date: Mon, 17 May 2010 09:01:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Julia Lawall <julia@diku.dk>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/10] security/selinux/ss: Use kstrdup
In-Reply-To: <Pine.LNX.4.64.1005142130140.28935@ask.diku.dk>
Message-ID: <alpine.LRH.2.00.1005170901160.12313@tundra.namei.org>
References: <Pine.LNX.4.64.1005142130140.28935@ask.diku.dk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Use kstrdup when the goal of an allocation is copy a string into the
> allocated region.
> 

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
