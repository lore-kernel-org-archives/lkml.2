Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0KSVS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:18:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50470 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab0KSVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:18:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sMRCZWIUHPdQUKUNi1Zclq4ckj4mK9IkRCbJIsAKYRVLbJEs1d24mdljYBQX3EMlQG
         M1P8meDBzMd0RzP6Z725vc3D54J8QYAOWDDXV1wV0SK7XFpu2YJ+ZTtfIy1iU5RMvKW9
         8pIHRMNbWr4NS31lodBxcnfKB8k1LK1ys4ECQ=
Message-ID: <4CE6E9B2.1040005@gmail.com>
Date: Fri, 19 Nov 2010 22:18:42 +0100
From: =?ISO-8859-9?Q?Niccol=F2_Belli?= <darkbasic4@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101102 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Ng Oon-Ee <ngoonee@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        linux-kernel@vger.kernel.org,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        johnstul@us.ibm.com, rostedt@goodmis.org, npiggin@suse.de
Subject: Re: 2.6.3x-rty where x > 3 and y >= 1?
References: <4CDAF425.4050800@ccrma.stanford.edu>	 <alpine.LFD.2.00.1011102154330.2900@localhost6.localdomain6>	 <4CDC0429.8090506@gmail.com> <1289515742.14141.0.camel@localhost.localdomain>
In-Reply-To: <1289515742.14141.0.camel@localhost.localdomain>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/11/2010 23:49, Ng Oon-Ee ha scritto:
>> Glad to hear that, I can't use 2.6.33-rt anymore because of problems
>> with my intel video card and my band is starting to blame because of xruns.
>>
>> Darkbasic
> 
> In the meantime, the -bfs kernel does improve the situation somewhat.

I just compiled 2.6.36-bfs, but unfortunately alsa git does not compile
against it (I need alsa git because of M-Audio Fast Track Ultra support).

Darkbasic
