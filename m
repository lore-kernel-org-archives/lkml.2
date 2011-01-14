Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1ANAlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:41:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:50318 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1ANAle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:41:34 -0500
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>, Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
In-Reply-To: <4D2F9948.8000804@kernel.org>
References: <4D2BF9F3.5080709@kernel.org>
	 <1294731467.17779.352.camel@pasglop>
	 <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
	 <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org>
	 <1294799565.9586.13.camel@pasglop> <4D2F7AE9.2000809@kernel.org>
	 <20110113224450.GA14918@kroah.com>
	 <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
	 <4D2F84FC.7000804@kernel.org> <20110113234852.GB17904@kroah.com>
	 <4D2F9948.8000804@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 11:40:35 +1100
Message-ID: <1294965635.4875.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 16:31 -0800, Yinghai Lu wrote:
> there are some udelay() in drivers/usb/early/ehci-dbgp.c
> 
> that is for early USB debug port console support.
> 
> We should replace them with early version udelay()

Or have a reasonable default for lpj ...

Ben.


