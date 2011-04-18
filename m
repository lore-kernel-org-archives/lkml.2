Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1DRWVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:21:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1DRWVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:21:31 -0400
Date: Tue, 19 Apr 2011 00:21:30 +0200
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        bluesmoke-devel@lists.sourceforge.net, linux-edac@vger.kernel.org
Subject: Re: [PATCH 31/34] edac: Drop __DATE__ usage
Message-ID: <20110418222130.GH29882@sepie.suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-32-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302015561-21047-32-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 04:59:18PM +0200, Michal Marek wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: bluesmoke-devel@lists.sourceforge.net
> Cc: linux-edac@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/edac/amd76x_edac.c  |    2 +-
>  drivers/edac/amd8111_edac.c |    2 +-
>  drivers/edac/amd8131_edac.c |    2 +-
>  drivers/edac/cpc925_edac.c  |    2 +-
>  drivers/edac/e752x_edac.c   |    2 +-
>  drivers/edac/e7xxx_edac.c   |    2 +-
>  drivers/edac/edac_module.c  |    2 +-
>  drivers/edac/i5000_edac.c   |    2 +-
>  drivers/edac/i5400_edac.c   |    2 +-
>  drivers/edac/i7300_edac.c   |    2 +-
>  drivers/edac/i7core_edac.c  |    2 +-
>  drivers/edac/i82860_edac.c  |    2 +-
>  drivers/edac/i82875p_edac.c |    2 +-
>  drivers/edac/i82975x_edac.c |    2 +-
>  drivers/edac/mpc85xx_edac.h |    2 +-
>  drivers/edac/mv64x60_edac.h |    2 +-
>  drivers/edac/ppc4xx_edac.c  |    2 +-
>  drivers/edac/r82600_edac.c  |    2 +-
>  18 files changed, 18 insertions(+), 18 deletions(-)

Applied to kbuild-2.6.git#trivial.

Michal

