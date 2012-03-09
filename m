Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2CIWaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:30:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab2CIWau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:30:50 -0500
Date: Fri, 9 Mar 2012 19:25:50 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: joerg.roedel@amd.com, avi@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: svm: count all irq windows exit
Message-ID: <20120309222550.GB24975@amt.cnet>
References: <20120308100756.3984.25343.stgit@amd-6168-8-1.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308100756.3984.25343.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 06:07:56PM +0800, Jason Wang wrote:
> Also count the exits of fast-path.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/x86/kvm/svm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

