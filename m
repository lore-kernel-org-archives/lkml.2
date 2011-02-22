Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1BVVII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:08:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44042 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1BVVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:08:07 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=b8VkJ_G4jssA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=8srmTA65Aarrmt9qkEsA:9 a=rIl6-Rn0IhY-cJJJBW958glmBDYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rt2x00: Use ops name instead of device name
From: Steven Rostedt <rostedt@goodmis.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, abogani@texware.it
In-Reply-To: <20110222194724.GG12153@tuxdriver.com>
References: <1298380368.6140.1193.camel@gandalf.stny.rr.com>
	 <1298381695.2211.486.camel@localhost>
	 <1298382263.6140.1196.camel@gandalf.stny.rr.com>
	 <AANLkTinNUnq7JQDpTzCv24A7T7fMn9iPFisQEBZGkELr@mail.gmail.com>
	 <20110222194724.GG12153@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Feb 2011 16:08:04 -0500
Message-ID: <1298408884.7666.68.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 14:47 -0500, John W. Linville wrote:

> I completely missed this series -- please be sure to Cc:
> linux-wireless@vger.kernel.org if you resend, and/or resend the series
> directly to me?

Hi John,

Not sure which series you were talking about. I sent out a single patch
and Cc'd you on it. But I should have sent it to linux-wireless, instead
of the net-dev list.

I don't plan on sending out any new patches. This should fix the issue.

Thanks,

-- Steve


