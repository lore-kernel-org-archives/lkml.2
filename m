Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab1HaOQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:16:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab1HaOQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:16:09 -0400
Date: Wed, 31 Aug 2011 16:16:07 +0200
From: Michal Marek <mmarek@suse.cz>
To: Corentin Chary <corentincj@iksaif.net>
Cc: linux-kernel@vger.kernel.org, Dick Streefland <dick@streefland.net>,
        WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3] scripts: add extract-vmlinux
Message-ID: <20110831141607.GA30387@sepie.suse.cz>
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
 <1313484365-22129-1-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313484365-22129-1-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 10:46:05AM +0200, Corentin Chary wrote:
> This script can be used to extract vmlinux from a compressed
> kernel image (bzImage, etc..). It's inspired from (a subset of)
> extract-ikconfig.
> 
> It's something a lot of people have been looking for (mainly
> people with xen < 4 that doesn't support bzImages at all).
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> ---
> 
> Since v1:
> * update license
> 
> Since v2:
> * add some comments
> 
>  scripts/extract-vmlinux |   62 +++++++++++++++++++++++++++++++++++++++++++++++

Applied to kbuild-2.6.git#misc, thanks.

Michal
