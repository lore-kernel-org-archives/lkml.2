Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2AJMlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:41:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2AJMlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:41:53 -0500
Date: Tue, 10 Jan 2012 10:39:38 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Avi Kivity <avi@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: unnecessary NX state assignment
Message-ID: <20120110123938.GA31611@amt.cnet>
References: <1325858778.3395.4.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325858778.3395.4.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 03:06:18PM +0100, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> We can remove the first ->nx state assignment since it is assigned afterwards anyways.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/x86/kvm/mmu.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Applied, thanks.

