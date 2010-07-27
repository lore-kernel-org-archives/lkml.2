Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab0G0QfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:35:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43378 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0G0QfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=lZ1uPYCWz7zjgnPWs9TZQt072rzWumGt4sl4uHKyIIQtseLJ4UXi3ehjeS6kO8pEjS
         QVGRwbAk/0mZTDuHy8fZjZCqYSJ6Y+gXARqc39biziq9eMkkPT8FnE8/pGCO+FVByApH
         hw68U5j2ksEIp3VmTZpb9c1y2CoC+zHKlofvY=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <4C4F0032.1010706@gmail.com>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
	<4C4F0032.1010706@gmail.com>
Date: Tue, 27 Jul 2010 17:35:16 +0100
Message-ID: <AANLkTin+a3V5Lydg__XGZwTDZbUKqeyHY4X57bBpc0CS@mail.gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
From: trapDoor <trapdoor6@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 4:50 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 07/27/2010 07:46 AM, trapDoor wrote:
>>
>> Hello,
>> I've just got lucky and found this little typo under "Power management
>> and ACPI options"  --->  "ACPI (Advanced Configuration and Power
>> Interface) Support":
>> hArdware Error Device
>>
>> Here is my fix:
>> Hardware Error Device
>> :)
>>
>> BTW, first time I've used nconfig instead of menuconfig. And I like it.
>>
>
> probably should create a patch, and send it to trivial@kernel.org
>
> Justin P. Mattock
>

Sure, but I don't know which script generates that part of config and
... how to do the patch :| (Sorry, I'm not even a greenhorn on the
programming field).
Just cc-eding trivial@kernel.org for now ..

-- 
Regards
trapDoor
