Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750768Ab0G0PuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 11:50:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57009 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0G0PuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 11:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BQl76MOZm3ncR53WFPAy1+ifVRGp5yLI7djyvDTupDH5eUnvEX1k9Zxq6smeMXsv7x
         vQL2hrYDJkLeshjeKbfV/Vd4/Dn2td4fLpXmIllV4CKjOq1dIR1Zy0IE6/+jSmxLG20c
         lqhbhDILkYvwGO17dLklG7b7DwNS3/gwm9+Hc=
Message-ID: <4C4F0032.1010706@gmail.com>
Date: Tue, 27 Jul 2010 08:50:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: trapdoor6@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Small typo in kernel [current source from git] .config option
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
In-Reply-To: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 07:46 AM, trapDoor wrote:
> Hello,
> I've just got lucky and found this little typo under "Power management
> and ACPI options"  --->  "ACPI (Advanced Configuration and Power
> Interface) Support":
> hArdware Error Device
>
> Here is my fix:
> Hardware Error Device
> :)
>
> BTW, first time I've used nconfig instead of menuconfig. And I like it.
>

probably should create a patch, and send it to trivial@kernel.org

Justin P. Mattock
