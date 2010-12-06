Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0LFTvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:51:35 -0500
Received: from www.tglx.de ([62.245.132.106]:55787 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab0LFTve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:51:34 -0500
Date: Mon, 6 Dec 2010 20:51:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, feng.tang@intel.com, len.brown@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86: Unify current 3 similar ways of saving
 IRQ info
In-Reply-To: <4CFD226C.60308@kernel.org>
Message-ID: <alpine.LFD.2.00.1012062050180.2653@localhost6.localdomain6>
References: <1291349518-3502-1-git-send-email-feng.tang@intel.com> <tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org> <4CFD226C.60308@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Yinghai Lu wrote:

> 
> it breaks compiling when CONFIG_X86_MPPARSE is not defined.
> 
> obj-$(CONFIG_X86_MPPARSE)       += mpparse.o

Crap. Missed that.

Thanks,

	tglx
