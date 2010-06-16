Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab0FPHBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:01:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42204 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab0FPHBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pTqFuzYDxhRzsUz0x3Aj3I46yCecL2RXVTdVfGTWl1cOjI0EowWAvcAhrznJJkYce7
         VQmgOJkOsSatcuhy0Fu/kxaJ+kZkk4J7pnDAutavCCfhtkUiT0PpIKFMfHQtIfEaLWLA
         bknqqeQpuGStkzNlM24jq+V9OVpYH9wCcIQIQ=
Message-ID: <4C1876BB.9030807@gmail.com>
Date: Wed, 16 Jun 2010 00:01:15 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix set but unused variable warnings
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com> <AANLkTikwKHITQJDaSf9BnHQ9FLiQ-KYlCWNiH438otsV@mail.gmail.com>
In-Reply-To: <AANLkTikwKHITQJDaSf9BnHQ9FLiQ-KYlCWNiH438otsV@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:52 PM, Julian Calaby wrote:
> On Wed, Jun 16, 2010 at 15:33, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> Here is another set of patches fixing some warning messages generated
>> when building the kernel when using gcc 4.6.0.
>>
>> This set just focuses in on the variables warnings that are reported
>> to be unused. Keep in mind there are still lots more warning messages
>> that I'm seeing, and will try my hardest to see if I can come up with
>> a fix, but if things become too difficult and so forth then a bug should
>> be filled etc..
>
> Given that patches 3, 4 and 5 seem to be a cases of missing error
> handling, (3 and 4 in particular seem to be breaking things rather
> than fixing them) in my humble opinion, I think this set needs some
> work and discussion.
>

alright..

> Justin, maybe you'd be better off posting the actual error messages
> (split up by subsystem) and letting the lists discuss them, rather
> than posting patches which are obviously wrong. (like the ones I've
> pointed out)
>

yeah I'm a newbie!! alright so just file bugs for all these then.

> I'm sure that everyone here is as committed as you are to eliminating
> compile warnings and errors and, in my opinion, more good will come
> from a healthy discussion of the warnings than maintainers NAKing your
> patches out of hand.
>
> Thanks,
>


NAKing is o.k. but having discussions is better..

Justin P. Mattock
