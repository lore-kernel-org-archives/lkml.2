Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0F2XSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:18:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:35644 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab0F2XSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:18:35 -0400
Date: Wed, 30 Jun 2010 09:18:32 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4] security: Yama LSM
In-Reply-To: <20100628184200.GU4175@outflux.net>
Message-ID: <alpine.LRH.2.00.1006300854170.14620@tundra.namei.org>
References: <20100628184200.GU4175@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Kees Cook wrote:

> This adds the Yama Linux Security Module to collect several security
> features (symlink, hardlink, and PTRACE restrictions) that have existed
> in various forms over the years and have been carried outside the mainline
> kernel by other Linux distributions like Openwall and grsecurity.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

There were no further complaints, and we seem to have reached a workable 
consensus on the topic.

It's not clear yet whether existing LSMs will modify their base policies 
to incorporate these protections, utilize the Yama code more directly, or 
implement some combination of both.

If you're a user of an existing LSM and want these protections, bug the 
developers for a solution :-)

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
