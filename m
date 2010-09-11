Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0IKAqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:46:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56298 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab0IKAqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OvatyXwd0hY4JDIDj21sJ+8dZyrf5EvH8xbFIWgd8CAZl1GwygEKGyM91bQo2vS44r
         XeAKEjBbeWHVZCnTPqlu9eItvvwyHVhwy+hgzkMdq/fGJCYwOhwoq2FcoVbW7GExZHuk
         5inKWlIRNoDOCyso792NiWuSSYCLkvhRpIEs0=
Message-ID: <4C8AD17B.6000407@gmail.com>
Date: Fri, 10 Sep 2010 17:46:51 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
        dri-devel@lists.sourceforge.net
Subject: Re: after closing the lid and reopening it the screen remains blank
References: <20100909224117.GA30000@gamma.logic.tuwien.ac.at> <20100910184751.GA17794@hexapodia.org> <20100910234448.GB9848@gamma.logic.tuwien.ac.at> <20100911003459.GW23291@hexapodia.org>
In-Reply-To: <20100911003459.GW23291@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 05:34 PM, Andy Isaacson wrote:
> On Sat, Sep 11, 2010 at 08:44:48AM +0900, Norbert Preining wrote:
>> On Fr, 10 Sep 2010, Andy Isaacson wrote:
>>> FWIW, 2.6.36-rc3-00396-gbe6200a suspend-to-ram works for me on GM45
>>
>> I never said that it has anything to do with suspend to ram.
>
> Ah, sorry for misunderstanding.  My GM45 system is configured to
> automatically S2R on lid close so I tend to conflate the two...
>
>> In fact, suspend to ram works perfectly without any problems. I only
>> reboot after I installed a new kernel ...
>>
>> I will try some older kernels and see if it is a kernel or userspace
>> issue.
>
> Do try the current tip and/or describe which post-rc3 kernel fails for
> you, just to verify.  Also, is there anything in Xorg.0.log from when it
> fails to restore the video?
>
> Thanks for reporting the regression, it'll be good to get it fixed ASAP.
>
> -andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


over here:
cat /etc/acpi/sleep.sh

if grep -q close /proc/acpi/button/lid/LID0/state
then
/usr/sbin/s2ram
fi

works reliably over here(knock on wood..)with radeon not sure
with intel cards..

Justin P. Mattock
