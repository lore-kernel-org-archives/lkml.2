Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1CAPrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:47:52 -0500
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:50242 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756742Ab1CAPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:47:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=MmvwbJ+2MrS057W5Nr+qGHTvHWHzhXLH1tfQikLc+UX8W1T1D0MyQFnFf39d9Rdl;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D6D151D.8030307@earthlink.net>
Date: Tue, 01 Mar 2011 10:47:41 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Tejun Heo <tj@kernel.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Subject: Re: NEC ND-4550A problems reading DVD-R
References: <m339n7g7tw.fsf@intrepid.localdomain> <20110301080153.GA26074@htj.dyndns.org> <4D6CF92A.4020105@teksavvy.com>
In-Reply-To: <4D6CF92A.4020105@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec795bc4b61235e71ea9e10bde4a9f02cbab350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 08:48 AM, Mark Lord wrote:
> On 11-03-01 03:01 AM, Tejun Heo wrote:
> ..
>    
>> I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
>> hardcoded to be 30 seconds.  Maybe it's better to move it to use the
>> block parameter.  Anyways, the drive actually takes longer than 30secs
>> to recognize the media?
>>      
> That slow behaviour is not uncommon, especially as drives struggle
> to recognize various forms of copy-protected media (DVD-Video).
> A longer default, or tuneable timeout, would help.
>
> Cheers
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
I agree with Mark, this should be a user tuneable value. My 2006 LG 
dvd-rw frequently times out
trying to identify the media. But after numerous timeout error messages 
it usually suceeds.

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



