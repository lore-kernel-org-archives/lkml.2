Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1FGO0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:26:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:39984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1FGO0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:26:21 -0400
Date: Tue, 7 Jun 2011 14:25:49 +0000
From: Konrad Rzeszutek <konrad@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: [GIT PULL] stable/broadcom.ibft-bugfixes for 3.0-rc2
Message-ID: <20110607142549.GA3944@hera.kernel.org>
References: <20110607000452.GA8607@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607000452.GA8607@hera.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Jun 2011 14:25:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 12:04:52AM +0000, Konrad Rzeszutek wrote:
> Hey Linus
> 
> Please pull:

If you haven't polled, please don't pull yet. linux-next noticed a bug with this
bug-fix, so let me get that fixed up first.


> 
>  git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git stable/broadcom.ibft-bugfixes
> 
> which is based of v3.0-rc1 tag. It has a small time compile warning when
> CONFIG_ACPI is not defined.
> 
> Connor Hansen (1):
>       iscsi_ibft: iscsi_ibft_find unused variable i
> 
>  drivers/firmware/iscsi_ibft_find.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
