Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2GTTW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:22:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab2GTTWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:22:54 -0400
Date: Fri, 20 Jul 2012 16:16:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: [PATCH] kvm: drop parameter validation
Message-ID: <20120720191610.GB24024@amt.cnet>
References: <20120719111313.GA4361@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719111313.GA4361@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 02:13:13PM +0300, Michael S. Tsirkin wrote:
> We validate irq pin number when routing is setup, so
> code handling illegal irq # in pic and ioapic on each injection
> is never called.
> Drop it.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Note: this is on top of
> 	[PATCHv2] kvm: fix race with level interrupts
> as these patches touch the same code.

"kvm: fix race with level interrupts" has been applied to next (branch
which contains next merge window group), which is in freeze mode (only 
critical fixes are accepted). 

This patch does not fall into that category, please resend once Linus
pulls the dependency.

