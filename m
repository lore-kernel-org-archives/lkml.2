Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab0HFBDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:03:17 -0400
Received: from mail.lang.hm ([64.81.33.126]:51965 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760482Ab0HFBDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:03:15 -0400
Date: Thu, 5 Aug 2010 18:01:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brian Swetland <swetland@google.com>
cc: paulmck@linux.vnet.ibm.com, kevin granade <kevin.granade@gmail.com>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
References: <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm> <20100805004802.GP24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm> <20100805151211.GA10080@linux.vnet.ibm.com> <alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm>
 <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com> <20100805203102.GN2447@linux.vnet.ibm.com> <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com> <alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm> <AANLkTikCCeMG=DAQ04xqkvqH9tngBWyBA5VQTD4_15xU@mail.gmail.com>
 <20100805230304.GQ2447@linux.vnet.ibm.com> <AANLkTinatKEBfHhMnKc5wbys13P81PKWSc+nxccgHe-Y@mail.gmail.com> <alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm> <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-349699584-1281056485=:25170"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-349699584-1281056485=:25170
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 5 Aug 2010, Brian Swetland wrote:

> On Thu, Aug 5, 2010 at 5:16 PM,  <david@lang.hm> wrote:
>>>>
>>>> So for an mp3 playback, does an Android suspend between data fetches?
>>>
>>> It can if the latency is long enough (which is why I point out low
>>> power audio which is usually high latency).  For low latency (system
>>> sounds, etc) 10-25ms between buffers it's not practical to fully
>>> suspend but we will go to the lowest power state in idle if possible.
>>
>> the playback is able to continue even with all the clocks stopped? that
>> surprises me. I would hav expected it to be able to sleep while playing
>> audio, but not do a full suspend.
>
> Obviously not all clocks are stopped (the DSP and codec are powered
> and clocked, for example), but yeah we can clock gate and power gate
> the cpu and most other peripherals while audio is playing on a number
> of ARM SoC designs available today (and the past few years).

does this then mean that you have multiple variations of suspend?

for example, one where the audio stuff is left powered, and one where it 
isn't?

David Lang
--680960-349699584-1281056485=:25170--
