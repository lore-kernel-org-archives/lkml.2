Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637Ab2CTKtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:49:55 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:46697 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759569Ab2CTKtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:49:35 -0400
Date: Tue, 20 Mar 2012 11:49:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steffen Persvold <sp@numascale.com>
Cc: Ingo Molnar <mingo@redhat.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH REPOST] Added separate apic_id_valid() functions for
 selected apic drivers.
Message-ID: <20120320104931.GA22880@gmail.com>
References: <CAE9FiQVxuVGe=m87fQKE+JjPk=Z83iOypQU+yQn5y-M-qVSArg@mail.gmail.com>
 <1331925935-13372-1-git-send-email-sp@numascale.com>
 <4F685EE8.5020708@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F685EE8.5020708@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steffen Persvold <sp@numascale.com> wrote:

> Ingo, any comments on this approach ? It should cover both 
> cases as suggested by Suresh and Yinghai.

Looks good in principle, but we are in the v3.4 merge window 
right now - new patches will have to wait a bit.

Thanks,

	Ingo
