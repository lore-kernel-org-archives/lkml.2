Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2B2IcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:32:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab2B2IcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:32:10 -0500
Date: Wed, 29 Feb 2012 09:31:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] iwlegacy cleanups
Message-ID: <20120229083147.GD2391@redhat.com>
References: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 12:25:29PM -0600, Greg Dietsche wrote:
> The first two patches reorganize the Kconfig for the iwlegacy drivers. This is
> intended to make the debug options appear in a more logical manner.
> 
> The second two patches remove some unused code from the iwlegacy driver.
> 
> These patches are based on the wireless-next tree.
> 
> Greg Dietsche (4):
>   iwlegacy: Kconfig: Move Debugging Options
>   iwlegacy: Kconfig: Change Debug Option to be more clear
>   iwlegacy: remove enum iw_calib and related code
>   iwlegacy: remove unused enum il4965_calib_enabled_state

ACK for series, thanks Greg.

Stanislaw
