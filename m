Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0IWXkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:40:53 -0400
Received: from tundra.namei.org ([65.99.196.166]:45201 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390Ab0IWXkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:40:51 -0400
Date: Fri, 24 Sep 2010 09:40:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: matt mooney <mfm@muteddisk.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 02/20] security/selinux: change to new flag variable
In-Reply-To: <1285224606-29493-1-git-send-email-mfm@muteddisk.com>
Message-ID: <alpine.LRH.2.00.1009240940070.4317@tundra.namei.org>
References: <1285224606-29493-1-git-send-email-mfm@muteddisk.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010, matt mooney wrote:

> Replace EXTRA_CFLAGS with ccflags-y.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

(with a couple of fixups).

-- 
James Morris
<jmorris@namei.org>
