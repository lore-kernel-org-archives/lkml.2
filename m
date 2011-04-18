Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1DRNER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:04:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1DRNEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:04:07 -0400
Date: Mon, 18 Apr 2011 15:04:05 +0200
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/34] kconfig: Do not record timestamp in auto.conf and
 autoconf.h
Message-ID: <20110418130405.GA9715@sepie.suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-2-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302015561-21047-2-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 04:58:48PM +0200, Michal Marek wrote:
> Timestamps in file data are useless and there is already one in .config
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/kconfig/confdata.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)

I pushed this to kbuild-2.6.git#kconfig.

Michal
