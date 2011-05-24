Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab1EXXIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:08:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41205 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab1EXXIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:02 -0400
Message-ID: <4DDC3A1A.6030006@zytor.com>
Date: Tue, 24 May 2011 16:07:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan>  <4DDC31DF.5010303@zytor.com> <1306278296.1921.10.camel@dan>
In-Reply-To: <1306278296.1921.10.camel@dan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 04:04 PM, Dan Rosenberg wrote:
> 
>> 2. Not introduce a performance regression (we avoid locating in the
>>    bottom 16 MiB for performance reasons, except on very small systems);
> 
> I altered the boot code so that it uses CONFIG_PHYSICAL_START, which
> defaults to 16 MiB, as a lower bound on location.  So nothing will ever
> get loaded below there, and I still can take advantage of higher
> alignment granularity.  Are there other problems I'm not anticipating?
> 

Please look at the discussion as to what led us to do things this way.

	-hpa
