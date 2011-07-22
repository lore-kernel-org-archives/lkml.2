Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1GVRw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 13:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab1GVRwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 13:52:54 -0400
Date: Fri, 22 Jul 2011 14:52:06 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Mike Waychison <mikew@google.com>
Cc: Cory Maccarrone <maccarro@google.com>, Andy Thornton <andrewth@google.com>,
        Miche Baker-Harvey <miche@google.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: get_msr support for HV_X64_MSR_APIC_ASSIST_PAGE
Message-ID: <20110722175206.GA6924@amt.cnet>
References: <1311287890-22124-1-git-send-email-mikew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311287890-22124-1-git-send-email-mikew@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 03:38:10PM -0700, Mike Waychison wrote:
> "get" support for the HV_X64_MSR_APIC_ASSIST_PAGE msr was missing, even
> though it is explicitly enumerated as something the vmm should save in
> msrs_to_save and reported to userland via the KVM_GET_MSR_INDEX_LIST
> ioctl.
> 
> Add "get" support for HV_X64_MSR_APIC_ASSIST_PAGE.  We simply return the
> guest visible value of this register, which seems to be correct as a set
> on the register is validated for us already.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>

Applied, thanks.

