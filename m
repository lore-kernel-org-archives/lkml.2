Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049Ab0EYVEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:04:10 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:62301 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0EYVEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VWVpVYhC/cX+Q1dOHD7Q2AiezBMC8ZyCftkJJOz7DWg+o4IhtvStgjorGwtr2FV9u9
         fAGIZIJm0eB0FObMkSxq/4l7eLaiKOmvwaDqd/LZ5WfjNDFMtMOqUODNLNDs2vvh1mn0
         1vyeotdJQu/Kv3SBGhi7F2pTdXpjhQD1SSc2M=
MIME-Version: 1.0
In-Reply-To: <20100525204405.GE4455@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.1005251359580.1634-100000@iolanthe.rowland.org>
	 <201005252147.22358.rjw@sisk.pl>
	 <20100525195300.GA4455@core.coreip.homeip.net>
	 <201005252221.55888.rjw@sisk.pl>
	 <20100525204405.GE4455@core.coreip.homeip.net>
Date: Tue, 25 May 2010 23:04:04 +0200
Message-ID: <AANLkTin98MXVaXJxizOsfYDkR2rl2Y6qVABf1qftAFWq@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Opportunistic suspend support.
From: Vitaly Wool <vitalywool@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Andi Kleen <ak@linux.intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 10:44 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

>> Now, we can reject their patches, but that's not going to cause any progress
>> to happen, realistically.  Quite on the contrary, Android will continue to use
>> wakelocks and Android driver writers will continue to ignore the mainline
>> and the gap between the two kernel lines will only get wider and wider over
>> time.
>>
>> And what really is the drawback if we merge the patches?  Quite frankly,
>> I don't see any.
>
> Adding stuff that is not beneficial to anyone but a particular platform?
> It is uncommon to say the least.

Yeah, I'd even say we're about to adopt mechanism which will provoke
adding drivers with buggy solutions.

Moving that stuff to platform-specific userspace will solve that, more or less.

Also, I'm less than happy about Android vs mainline talks that come
into play when out of the technical points. Google is doing a good job
but we shouldn't compromise neither the quality nor the principles in
order to make them happy. They will not support tons of drivers with
custom PM solution by themselves, so it's to mutual benefit if they
come with a satisfactory solution.

~Vitaly
