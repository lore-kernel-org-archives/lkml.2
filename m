Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2LRRmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:42:33 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:40463 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2LRRmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:42:31 -0500
MIME-Version: 1.0
In-Reply-To: <50D0A8CE.7040704@linux.intel.com>
References: <1355850450-26445-1-git-send-email-youquan.song@intel.com>
	<50D0A8CE.7040704@linux.intel.com>
Date: Tue, 18 Dec 2012 09:42:30 -0800
X-Google-Sender-Auth: GbSpkGykXIPpaS8eQBvy_52MUuk
Message-ID: <CAE9FiQUfCOip_dJM9gTVsiXH5iHHPzTsnp=sBz2ughMJh1HT8Q@mail.gmail.com>
Subject: Re: [PATCH] x86,apic: Blacklist x2APIC on some platforms
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 9:33 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 12/18/2012 09:07 AM, Youquan Song wrote:
>> Blacklist x2apic when Nivida graphics enabled on Lenovo ThinkPad T420.
>> Also set blacklist x2apic for Lenovo ThinkPad W520 and L520.
>
> I thought we had gotten reports that the Nvidia correlation was false?

that's T520.
