Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0IGUtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:49:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34821 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab0IGUtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:49:20 -0400
Message-ID: <4C86A531.1010801@zytor.com>
Date: Tue, 07 Sep 2010 13:48:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
References: <20100901213318.19353.54619.stgit@localhost.localdomain>	 <20100902065731.GB29972@elte.hu> <20100902100308.GA17167@basil.fritz.box>	 <20100903063934.GA25863@elte.hu> <1283888337.18468.9.camel@pjaxe>	 <4C869AA3.6000103@zytor.com> <1283890615.18468.11.camel@pjaxe>
In-Reply-To: <1283890615.18468.11.camel@pjaxe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2010 01:16 PM, Peter P Waskiewicz Jr wrote:
>>
>> If this is a production BIOS it should have this information.
> 
> Responding for both your and Ingo's last email, I'll work on getting a
> DMI match for this system.
> 

Great.

	-hpa
