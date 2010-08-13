Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0HMXRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:17:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34696 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab0HMXRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:17:40 -0400
Message-ID: <4C65D263.6050904@zytor.com>
Date: Fri, 13 Aug 2010 16:16:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Luck\, Tony" <tony.luck@intel.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>
Subject: Re: [PATCH][EFI] Run EFI in physical mode
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>	<4C65C630.4070008@zytor.com>	<987664A83D2D224EAE907B061CE93D53015B2DAD87@orsmsx505.amr.corp.intel.com> <m1r5i2kt0n.fsf@fess.ebiederm.org>
In-Reply-To: <m1r5i2kt0n.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 04:11 PM, Eric W. Biederman wrote:
> 
> As to Peter's question I did not see any of that code that affected
> anything that ia64 used.
> 

I guess my real question was "is this something IA64 could benefit from
and/or could we make the IA64 code more similar to the x86 bits"?

	-hpa

