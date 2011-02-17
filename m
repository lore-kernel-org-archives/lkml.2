Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1BQNN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:13:59 -0500
Received: from www.tglx.de ([62.245.132.106]:59035 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab1BQNN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:13:57 -0500
Date: Thu, 17 Feb 2011 14:13:40 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>
Subject: Re: [sodaville] [PATCH OF 12/14] x86/rtc: don't register rtc if we the DT blob
Message-ID: <20110217131340.GA13500@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-13-git-send-email-bigeasy@linutronix.de> <20110216220921.GI22837@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110216220921.GI22837@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-02-16 15:09:21 [-0700]:

>> @@ -236,6 +237,8 @@ static __init int add_rtc_cmos(void)
>>  		}
>>  	}
>>  #endif
>> +	if (of_have_populated_dt())
>> +		return 0;
>
>Hmmm, should this hunk be moved to the next patch to preserve bisectability?

Makes sense. Without this chunk it is simply adding
of_have_populated_dt(). So I merge with the next patch.

>g.

Sebastian
