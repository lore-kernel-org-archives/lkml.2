Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0GKXpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 19:45:39 -0400
Received: from tundra.namei.org ([65.99.196.166]:47629 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab0GKXpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 19:45:36 -0400
Date: Mon, 12 Jul 2010 09:45:14 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 13/18] ima: use generic_file_llseek for securityfs
In-Reply-To: <1278538820-1392-14-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LRH.2.00.1007120944410.11718@tundra.namei.org>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-14-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010, Arnd Bergmann wrote:

> The default for llseek will change to no_llseek,
> so securityfs users need to add explicit .llseek
> assignments. Since we're dealing with regular
> files from a VFS perspective, use generic_file_llseek.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mimi Zohar <zohar@us.ibm.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: linux-security-module@vger.kernel.org
> ---
>  security/integrity/ima/ima_fs.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next



-- 
James Morris
<jmorris@namei.org>
