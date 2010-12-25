Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0LYPCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 10:02:46 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:37417 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab0LYPCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 10:02:45 -0500
Date: Sat, 25 Dec 2010 16:02:40 +0100
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Don't leak memory in btrfs_get_acl()
Message-ID: <20101225150240.GA7938@mako-laptop>
References: <alpine.LNX.2.00.1012242342280.28973@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012242342280.28973@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 11:45:21PM +0100, Jesper Juhl wrote:
> Hi,
> 
> Currrently we leak memory in btrfs_get_acl::btrfs_get_acl() if 
> posix_acl_from_xattr() fails. With this patch we do not.

I sent similar patch some time ago but no reply from Chris so far.

http://marc.info/?l=linux-kernel&m=129247984126414

-- 
Mariusz Kozlowski
