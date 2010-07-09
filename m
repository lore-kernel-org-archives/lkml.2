Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0GIHIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:08:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60048 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0GIHIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QQUBuek3JLSnZraPXmy3jQCEa1ZIUa37XARqaM872bsQVfoK2WoQKNvB2w1usjdWC+
         19cupZY1J8UVVfmzJ2VVhbi2KR15rI18yvG7xjuBf6ZtyY6L0LUBbyRMGHUQzSjZ5t/6
         wSo5xEgIo5OnoSKAhI69aaT2lsm03qh7qYygA=
MIME-Version: 1.0
In-Reply-To: <20100709115010.CD72.A69D9226@jp.fujitsu.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
	<TXb9XdQzJoD.A.n2D.8NmNMB@chimera>
	<20100709115010.CD72.A69D9226@jp.fujitsu.com>
Date: Fri, 9 Jul 2010 17:08:47 +1000
Message-ID: <AANLkTine2GbsnGfqZLzgDq2AWmAPpHqjDUugumpX2Ymv@mail.gmail.com>
Subject: Re: [Bug #16175] 2.6.35-rc1 system oom, many processes killed but 
	memory not free
From: Andrew Hendry <andrew.hendry@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes this one can be closed, it was ramdisk too big.

On Fri, Jul 9, 2010 at 12:53 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> This message has been generated automatically as a part of a summary report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.34.  Please verify if it still should be listed and let the tracking team
>> know (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=16175
>> Subject               : 2.6.35-rc1 system oom, many processes killed but memory not free
>> Submitter     : andrew hendry <andrew.hendry@gmail.com>
>> Date          : 2010-06-05 0:46 (34 days old)
>> Message-ID    : <AANLkTim7CiW-yfugZUAHZCqLvXKgt9CwolCvbLGdCLAk@mail.gmail.com>
>> References    : http://marc.info/?l=linux-kernel&m=127569877714937&w=2
>
> Andrew, I think this ticket can be closed, right?
>
> Rafael, can you please see following discussion?
>
> http://marc.info/?l=linux-kernel&m=127744262109629&w=2
>
>
