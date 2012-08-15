Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2HOTJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:09:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2HOTJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:09:41 -0400
Date: Wed, 15 Aug 2012 15:31:42 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, glommer@redhat.com
Subject: Re: [PATCH V2] KVM: x86: disable stealtime on reboot to avoid mem
 corruption
Message-ID: <20120815183142.GC21271@amt.cnet>
References: <1345039240-29959-1-git-send-email-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345039240-29959-1-git-send-email-fw@strlen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:00:40PM +0200, Florian Westphal wrote:
> else, host continues to update stealtime after reboot,
> which can corrupt e.g. initramfs area.
> found when tracking down initramfs unpack error on initial reboot
> (with qemu-kvm -smp 2, no problem with single-core).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.

