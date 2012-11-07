Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2KGJtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:49:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38608 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2KGJtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:49:12 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20121106204756.GA12142@jshin-Toonie>
References: <20121019085519.GC26718@alberich> <20121106204756.GA12142@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] x86, cacheinfo: Use AMD topology extensions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 07 Nov 2012 10:48:35 +0100
To: Jacob Shin <jacob.shin@amd.com>, x86@kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, herrmann.der.user@googlemail.com
Message-ID: <e7f34d69-2cb0-4ae7-9501-58af69308461@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Too many of us at LCE right now...

Jacob Shin <jacob.shin@amd.com> wrote:

>On Fri, Oct 19, 2012 at 10:55:19AM +0200, Andreas Herrmann wrote:
>> Hi,
>> 
>> Following patches modify cachinfo code to make use of AMD's topology
>> extension CPUID functions. Thus (hopefully) we can avoid CPU specific
>> modifications whenever cache topology changes.
>> 
>> Please apply.
>
>Acked-by: Jacob Shin <jacob.shin@amd.com>
>
>
>
>Ping ?
>
>Any feedback ? If not could we get it into tip ?
>
>Thank you,
>
>> 
>> 
>> Thanks,
>> 
>> Andreas
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> 
>> 
>> 

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
