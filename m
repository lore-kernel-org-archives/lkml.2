Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1DAD1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 23:27:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64536 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1DAD1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 23:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tsCqyaSTf1QEZ/OMS/e6BHYZ/AvDcmHjVgMbC2R1ANVqoNcNlU0chgUt1LUjU1EFYd
         uRP5TMwTpxi71s4J6ZE2LOKVQRFtCA7bzmYY5aBwuXK0dIad+thQDn9K2lkYXipThn9e
         wpWBkpyizXxBf1MEfGz9jOzuGF/wcmhLP51us=
MIME-Version: 1.0
In-Reply-To: <4D952B76.7000201@silka.with-linux.com>
References: <AANLkTin17=rCU4eDGYtnVFZ1ffbUn+var4Q_AQUuGKaw@mail.gmail.com>
	<4D946C73.4090402@ladisch.de>
	<AANLkTinyRqEa_ML47DOqAJU8aLDEA12geiUUrPGjXHrN@mail.gmail.com>
	<4D94F728.60609@silka.with-linux.com>
	<4D952B76.7000201@silka.with-linux.com>
Date: Fri, 1 Apr 2011 05:05:54 +0200
Message-ID: <AANLkTi=g6C5T3x-GoncuHNvhZ1r3h8WOjmouYR0JqpFz@mail.gmail.com>
Subject: Re: Linux 2.6.38 freeze because of sound/core/pcm_lib.c commit 59ff878ffb26bc0be812ca8295799164f413ae88
From: "Christopher K." <c.krooss@googlemail.com>
To: Kelly Anderson <kelly@silka.with-linux.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 03/31/11 15:50, Kelly Anderson wrote:
>>
>> Just to let you know.  I'm using a gtx460 also.  I haven't had a chance to
>> reboot into the newly patched kernel yet.  It is interesting that we both
>> have gtx460's.  I have a machine with a gtx430 that doesn't seem to exhibit
>> the problem.
>>
>> cat /etc/modprobe.d/snd_hda_intel.conf
>>
>> options snd-hda-intel probe_mask=-1,0xa
>>
> OK, I debugged the problem and came up with a solution.  The bottom line is
> that it's a problem with a signed to unsigned compare.  First the fix:

I can confirm that this patch fixes the issue. Thanks a lot!
