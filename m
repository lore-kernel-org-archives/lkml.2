Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab2EaX5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:57:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758692Ab2EaX5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:57:33 -0400
Date: Thu, 31 May 2012 19:07:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiantao Zhang <xiantao.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] KVM: ia64: Mark ia64 KVM as BROKEN
Message-ID: <20120531220737.GA19287@amt.cnet>
References: <1337249648-16894-1-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337249648-16894-1-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 01:14:08PM +0300, Avi Kivity wrote:
> Practically all patches to ia64 KVM are build fixes; numerous warnings remain;
> the last patch from the maintainer was committed more than three years ago.  It
> is clear that no one is using this thing.
> 
> Mark as BROKEN to ensure people don't get hit by pointless build problems.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>

Applied, thanks.

