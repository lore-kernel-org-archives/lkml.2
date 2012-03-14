Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab2CNA4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:56:25 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:13081 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627Ab2CNA4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:56:24 -0400
Message-ID: <4F5FECB5.3090806@tilera.com>
Date: Tue, 13 Mar 2012 20:56:21 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the tile tree with Linus' tree
References: <20120314111057.499d4901f51264c2012fd2b1@canb.auug.org.au>
In-Reply-To: <20120314111057.499d4901f51264c2012fd2b1@canb.auug.org.au>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2012 8:10 PM, Stephen Rothwell wrote:
> Hi Chris,
>
> Today's linux-next merge of the tile tree got a conflict in arch/Kconfig
> between commit 43570fd2f47b ("mm,slub,x86: decouple size of struct page
> from CONFIG_CMPXCHG_LOCAL") (and a couple after) from Linus' tree and
> commit ca3a3d347e23 ("ipc: provide generic compat versions of IPC
> syscalls") from the tile tree.
>
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.

Thanks!  I'll sync up that tree over the next couple of days as I start
pushing out some more changes to get ready for 3.4 merge window.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

