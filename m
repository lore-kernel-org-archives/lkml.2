Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1ANAct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:32:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21380 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1ANAcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:32:43 -0500
Message-ID: <4D2F9948.8000804@kernel.org>
Date: Thu, 13 Jan 2011 16:31:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Jason Wessel <jason.wessel@windriver.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
References: <4D2BF9F3.5080709@kernel.org> <1294731467.17779.352.camel@pasglop> <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com> <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org> <1294799565.9586.13.camel@pasglop> <4D2F7AE9.2000809@kernel.org> <20110113224450.GA14918@kroah.com> <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6> <4D2F84FC.7000804@kernel.org> <20110113234852.GB17904@kroah.com>
In-Reply-To: <20110113234852.GB17904@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there are some udelay() in drivers/usb/early/ehci-dbgp.c

that is for early USB debug port console support.

We should replace them with early version udelay()

Thanks

Yinghai
