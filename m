Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2CRQqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 12:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2CRQqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 12:46:17 -0400
Date: Thu, 15 Mar 2012 21:06:35 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, jan.kiszka@siemens.com, avi@redhat.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unneeded EXPORT macro
Message-ID: <20120316000635.GA13145@amt.cnet>
References: <1331849809-17034-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331849809-17034-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 06:16:49PM -0400, Eric B Munson wrote:
> check_and_clear_guest_paused does not need to be exported as it isn't used
> by any modules, remove the export.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> Cc: mingo@redhat.com
> Cc: hpa@zytor.com
> Cc: ryanh@linux.vnet.ibm.com
> Cc: aliguori@us.ibm.com
> Cc: jan.kiszka@siemens.com
> Cc: avi@redhat.com
> Cc: kvm@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kernel/kvmclock.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Applied, thanks.

