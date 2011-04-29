Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab1D2MJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:09:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:39216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab1D2MJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:09:16 -0400
Date: Fri, 29 Apr 2011 14:09:13 +0200
From: Michal Marek <mmarek@suse.cz>
To: Peter Foley <pefoley2@verizon.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH V2 resend 0/7] kbuild: scripts/kconfig/Makefile cleanup
 and fixes
Message-ID: <20110429120912.GC1619@sepie.suse.cz>
References: <4DB88BF7.1030905@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB88BF7.1030905@verizon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 05:34:47PM -0400, Peter Foley wrote:
> This patch set:
> Changes the update-po-config target to work when make is run from
> KBUILD_OUTDIR.
> Changes the update-po-config target to reflect the new layout of arch/um.
> Adds a check to only build kxgettext when needed.
> Changes the qconf and gconf targets to change hostprogs-y when they are
> being built like nconf and mconf instead of defining *-objs.
> Cleans up the clean-files definitions.
> Silences comands unless V=1.
> 
> I've also attached the patches as requested by Michal Marek.

That worked, thanks. Pushed to kbuild-2.6.git#kconfig.

Michal
