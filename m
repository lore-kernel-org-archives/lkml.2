Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0IUKJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 06:09:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58848 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0IUKJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 06:09:20 -0400
Message-ID: <274e128f862a7ed5f6ba0a137133569d.squirrel@www.firstfloor.org>
In-Reply-To: <20100921082044.GS13563@erda.amd.com>
References: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
    <20100921082044.GS13563@erda.amd.com>
Date: Tue, 21 Sep 2010 12:09:15 +0200
Subject: Re: [PATCH] oprofile: Add Support for Intel CPU Family 6 / Model 29
From: "Andi Kleen" <andi@firstfloor.org>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Jiri Olsa" <jolsa@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        "tdm.rhbz@gmail.com" <tdm.rhbz@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 21.09.10 03:26:35, Jiri Olsa wrote:
>> This patch adds CPU type detection for dunnington processor (Family 6 /
>> Model 29)
>> to be identified as core 2 family cpu type (wikipedia source).
>>
>> I tested oprofile on Intel(R) Xeon(R) CPU E7440 reporting itself as
>> model 29,
>> and it runs without an issue.
>>
>> wbr,
>> jirka
>>
>>
>> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
>
> Andi,
>
> found this spec:
>
>  http://www.intel.com/Assets/en_US/PDF/specupdate/320336.pdf
>
> Please ack.

Acked-by: Andi Kleen <ak@linux.intel.com>

Thanks,
-Andi

