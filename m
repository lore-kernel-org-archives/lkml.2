Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2HVRsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:48:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40713 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2HVRsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:48:37 -0400
Date: Wed, 22 Aug 2012 19:48:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
Cc: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization
Message-ID: <20120822174832.GA32743@gmail.com>
References: <20120822100845.GB26323@gmail.com>
 <1345634411-28108-1-git-send-email-ido@wizery.com>
 <20120822173752.GA32500@gmail.com>
 <9B14D1490DDECA4E974F6B9FC9EBAB317F3897AEC7@VMBX108.ihostexchange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9B14D1490DDECA4E974F6B9FC9EBAB317F3897AEC7@VMBX108.ihostexchange.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shai Fultheim (Shai@ScaleMP.com) <Shai@ScaleMP.com> wrote:

> Ingo,
> 
> CONFIG_X86_VSMP is only for setting cache-line size to 4KB.  
> Rest of the bits were never depended on this.

That's a problem - please move vSMP functionality under a 
simple, properly named Kconfig toggle. Many of the build 
problems are related to that.

Thanks,

	Ingo
