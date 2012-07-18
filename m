Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2GRUVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:21:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab2GRUVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:21:49 -0400
Date: Wed, 18 Jul 2012 17:02:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, hyper: fix build with !CONFIG_KVM_GUEST
Message-ID: <20120718200208.GB18071@amt.cnet>
References: <1342601330-11044-1-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342601330-11044-1-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 11:48:50AM +0300, Avi Kivity wrote:
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/kernel/cpu/hypervisor.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied to next, thanks.

