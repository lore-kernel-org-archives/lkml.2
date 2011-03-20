Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab1CTOGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 10:06:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52863 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1CTOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 10:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KpYIO/cuHQltylynaTmkL6NdcchCW4hvzG5da6LK11PNCJWavByix0GFskO5EloJTg
         SO+n04V6ED65zzDAx68zhwIV4tROE07Awgj4p6zfIGlDJpol1/BB/j1LDr+5UljNRru9
         wsBUnLO5qgGrY/JxBw0S0F09ZOscnLv5EF9FY=
Message-ID: <4D8609F4.4040700@gmail.com>
Date: Sun, 20 Mar 2011 15:06:44 +0100
From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic4@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110315 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Remy Bohmer <linux@bohmer.net>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [000/474] 2.6.33.8-longterm review
References: <20110317213822.GA27980@kroah.com> <alpine.LFD.2.00.1103180942531.2787@localhost6.localdomain6> <AANLkTi=q-HEBKFe=DLXC36Acxd_LqgfYs=66wxs013Ac@mail.gmail.com> <alpine.LFD.2.00.1103201351570.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103201351570.2787@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/03/2011 13:52, Thomas Gleixner ha scritto:
> On Sat, 19 Mar 2011, Remy Bohmer wrote:
>> Can you please elaborate somewhat on the status of the RT-patchset
>> development for 2.6.38 and on?
> 
> Working on it.
> 
>> It is silent about it for quite a while now, and actually the gap
>> between mainstream and the latest RT has never been this big before...
>> Are there major complications, lack on time or hands? Can I help ?
> 
> I concentrated on getting stuff upstream and reworking to make it more
> palatable and maintainable.

Is there a working (where working means working for testing purposes)
snapshot somewhere?

Thanks,
Darkbasic
