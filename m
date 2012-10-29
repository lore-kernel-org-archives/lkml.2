Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab2J2Ky6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:54:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26715 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2J2Ky5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:54:57 -0400
X-IronPort-AV: E=Sophos;i="4.80,671,1344182400"; 
   d="scan'208";a="6092350"
Message-ID: <508E61D6.3080101@cn.fujitsu.com>
Date: Mon, 29 Oct 2012 19:00:38 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, bhelgaas@google.com,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/2] update mem= option's spec according to its implementation
References: <1351500524-23907-1-git-send-email-wency@cn.fujitsu.com>	<1351500524-23907-2-git-send-email-wency@cn.fujitsu.com> <CAFLxGvyOo065sc2QeTkFsPotJbJEgEAV_ktvz5Z2gYpD-Ft7WA@mail.gmail.com>
In-Reply-To: <CAFLxGvyOo065sc2QeTkFsPotJbJEgEAV_ktvz5Z2gYpD-Ft7WA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 18:54:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 18:54:14,
	Serialize complete at 2012/10/29 18:54:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/29/2012 06:48 PM, richard -rw- weinberger Wrote:
> On Mon, Oct 29, 2012 at 9:48 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
>> Current mem= implementation seems buggy because specification and
>> implementation doesn't match. Current mem= has been working
>> for many years and it's not buggy, it works as expected. So
>> we should update the specification.
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>
> 
> So, is this an ACK or not?
> 

I don't know.

Here is the origin message:

At 06/15/2012 04:22 AM, Rob Landley Wrote:
> I have no objection to this but can't confirm it's true or not without
> an awful lot more digging through the code I don't have time for right
> now. (All the x86-32 machines I've used just had the 640k->1m hole and
> the rest was contiguous memory, so the behavior would be the same either
> way...)
> 
> Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>
> 
> Rob
