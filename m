Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1DSMUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:20:13 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:45716 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579Ab1DSMUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BtgNpAHsDwha0AytZhGYKGlZKNf+LR6NKJ++8904223QYc0lMfVhR/Js7S3+vwfW+9
         8QPS8+q5DtDYLr9dG7/OHD7XknIMXjyjUghOn7fxyrw4d53PQJvI0MCzbhP+RIR1GnpM
         K8rqMiEJgve2cnapqB8C1TlONA5JJzp65BCOc=
MIME-Version: 1.0
In-Reply-To: <70E876B0EA86DD4BAF101844BC814DFE093FB40998@Cloud.RL.local>
References: <BANLkTi=7DbMrbo0nQU+268LC_2258q-_DA@mail.gmail.com>
	<70E876B0EA86DD4BAF101844BC814DFE093FB40998@Cloud.RL.local>
Date: Tue, 19 Apr 2011 08:20:09 -0400
Message-ID: <BANLkTinTMi76GmgO6HJ0+ifCXsHE3Mjsvg@mail.gmail.com>
Subject: Re: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Jon Povey <Jon.Povey@racelogic.co.uk>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        "Griffis, Brad" <bgriffis@ti.com>, Philby John <pjohn@in.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Mon, Apr 18, 2011 at 9:47 PM, Jon Povey <Jon.Povey@racelogic.co.uk> wrote:
> Ben Gardiner wrote:
>
>>>> When creating this series I noticed that there are obvious
>>>> similarities between the existing recovery routine implemented by
>>>> Philby John and John Povey
>
>> I'm not sure how the 20us in the existing method was derived -- I
>> wonder if Philby John or John Povey could comment?
>
> I've been a little bemused about why I am getting credited for I2C
> bus recovery work. I don't remember doing any work on that.

My mistake -- sorry. Also sorry for getting your name wrong repeatedly.

> I did a couple of patches to fix a race when setting up a TX, but
> those are, afaik, unrelated.

In "i2c-davinci: Fix race when setting up for TX" and "i2c-davinci:
Fix TX setup for more SoCs" you mention testing on DM355 -- is there
any you have hardware on which the recovery procedure is executed on
occasion and that you would be available to test modifications to the
current implementation?

> All I know about the bus recovery stuff is looking at it a while back
> and thinking hmm, that seems to wiggle gpio without changing the
> pinmuxing, so it can't possibly work.

:) Probably not then.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
