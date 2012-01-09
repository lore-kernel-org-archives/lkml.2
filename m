Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2AIMPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 07:15:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2AIMPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 07:15:22 -0500
Date: Mon, 9 Jan 2012 10:14:09 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Boris Ostrovsky <ostr@amd64.org>
Cc: avi@redhat.com, Joerg.Roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@amd.com
Subject: Re: [PATCH v2.1] KVM: SVM: Add support for AMD's OSVW feature in
 guests
Message-ID: <20120109121409.GE5255@amt.cnet>
References: <1325866436-22553-1-git-send-email-ostr@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325866436-22553-1-git-send-email-ostr@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 11:13:56AM -0500, Boris Ostrovsky wrote:
> From: Boris Ostrovsky <boris.ostrovsky@amd.com>
> 
> In some cases guests should not provide workarounds for errata even when the
> physical processor is affected. For example, because of erratum 400 on family
> 10h processors a Linux guest will read an MSR (resulting in VMEXIT) before
> going to idle in order to avoid getting stuck in a non-C0 state. This is not
> necessary: HLT and IO instructions are intercepted and therefore there is no
> reason for erratum 400 workaround in the guest.
> 
> This patch allows us to present a guest with certain errata as fixed,
> regardless of the state of actual hardware.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>

Patch does not apply, please regenerate against
git://git.kernel.org/pub/scm/virt/kvm/kvm.git master branch.

