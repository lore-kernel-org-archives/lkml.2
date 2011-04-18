Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1DRWUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:20:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1DRWUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:20:01 -0400
Date: Tue, 19 Apr 2011 00:20:00 +0200
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 21/34] aacraid: Drop __TIME__ usage
Message-ID: <20110418222000.GD29882@sepie.suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-22-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302015561-21047-22-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 04:59:08PM +0200, Michal Marek wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/scsi/aacraid/linit.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Applied to kbuild-2.6.git#trivial.

Michal

