Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0LPKAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:00:05 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:52214 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912Ab0LPKAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:00:01 -0500
Message-ID: <4D09E319.5000603@euromail.se>
Date: Thu, 16 Dec 2010 10:59:53 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Nauber <richard.nauber@googlemail.com>,
        Richard Nauber <Richard.Nauber@gmail.com>
Subject: Re: [PATCH] hid: egalax: Add support for Samsung NB30 netbook
References: <1292493175-21630-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1012161055060.16569@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1012161055060.16569@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTAcu-0001NT-7V.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PTAcu-0001NT-7V 56afe4f93f0e4f75bf607e075ccd4e47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 10:55 AM, Jiri Kosina wrote:

> On Thu, 16 Dec 2010, Henrik Rydberg wrote:
> 
>> From: Richard Nauber <richard.nauber@googlemail.com>
>>
>> The Samsung NB30 touch has a DWAV dual-touch device. This patch adds
>> the NB30 to the list of supported devices, and grabs it accordingly in
>> hid-core.
>>
>> [rydberg@euromail.se: rename and log message changes]
>> Signed-off-by: Richard Nauber <Richard.Nauber@gmail.com>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> ---
>> Hi Jiri,
>>
>> do I have your ACK on this one?
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> I will happily apply the patch to my queue. Or are you planning to put it 
> together with some larger bundle?


Thanks! Yep, it depends on a number of other patches coming in from my tree, so
we had better put in on top of that pile.

Thanks,
Henrik
