Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2CMHAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:00:14 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:41224 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2CMHAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:00:12 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq3M7qFLaZ
X-RZG-CLASS-ID: mo00
Date: Tue, 13 Mar 2012 08:00:02 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 020/196] staging: hv: use sync_bitops when
 interacting with the hypervisor
Message-ID: <20120313070002.GA19629@aepfle.de>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331597724-31358-21-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1331597724-31358-21-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, Paul Gortmaker wrote:

> From: Olaf Hering <olaf@aepfle.de>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit 22356585712d1ff08fbfed152edd8b386873b238 upstream.

Unless there is a happy user of the hv drivers in this old kernel, it
makes no sense to backport just this one patch.

I suggest to leave drivers/staging/hv alone in longterm releases, or
backport the entire history of drivers/staging/hv up to 3.4.

Olaf
