Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0LQTbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:31:55 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:48882 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab0LQTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lnRtYjA4MAW+MQ3lMUskM4CDYs8o6M4r0d1LRFYG7HryBEKoGdJ9LdQ4CH2S5ekOaa
         p5EZDVFxDZ7KxVtWfJaXT95wg68MY+Xet/9Oy/xy1vDnEDbcSNXO5J+uoYwn5ZDGbxCW
         HOy2BWrki/sGGIbyFCKzNtR/EkZrz14jbTML0=
MIME-Version: 1.0
In-Reply-To: <1292612385.2708.108.camel@laptop>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	<1292596194.2266.283.camel@twins>
	<1292612166.2697.68.camel@Palantir>
	<1292612385.2708.108.camel@laptop>
Date: Fri, 17 Dec 2010 20:31:51 +0100
Message-ID: <AANLkTikO56++q906A1XRbomeASY77wxeEuBqAdx=EttW@mail.gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Harald Gustafsson <hgu1972@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> We already did the very same thing (for another EU Project called
>> FRESCOR), although it was done in an userspace sort of daemon. It was
>> also able to consider other "high level" parameters like some estimation
>> of the QoS of each application and of the global QoS of the system.
>>
>> However, converting the basic mechanism into a CPUfreq governor should
>> be easily doable... The only problem is finding the time for that! ;-P
>
> Ah, I think Harald will solve that for you,.. :)

Yes, I don't mind doing that. Could you point me to the right part of
the FRESCOR code, Dario?
I will then compare that with what I already have.
