Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2H0TNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 15:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab2H0TNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 15:13:35 -0400
Date: Sun, 26 Aug 2012 15:12:00 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] kvm: Fix nonsense handling of compat ioctl
Message-ID: <20120826181200.GA27669@amt.cnet>
References: <20120822133400.20200.3726.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822133400.20200.3726.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 02:34:11PM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> KVM_SET_SIGNAL_MASK passed a NULL argument leaves the on stack signal
> sets uninitialized. It then passes them through to
> kvm_vcpu_ioctl_set_sigmask.
> 
> We should be passing a NULL in this case not translated garbage.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Applied, thanks.

