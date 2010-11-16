Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab0KPS4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:56:38 -0500
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:37091
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757049Ab0KPS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:56:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=pAzXgU2w+grihExfFz0NRaWNC0Vldsrb5NCtsjUgO3LCrnN+v73MGaitWsUpLk/w;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4CE2D3C6.20905@earthlink.net>
Date: Tue, 16 Nov 2010 13:56:06 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Lennart Poettering <mzxreary@0pointer.de>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
References: <1289783580.495.58.camel@maggy.simson.net>	 <1289811438.2109.474.camel@laptop>	 <1289820766.16406.45.camel@maggy.simson.net>	 <1289821590.16406.47.camel@maggy.simson.net>	 <20101115125716.GA22422@redhat.com>	 <1289856350.14719.135.camel@maggy.simson.net>	 <20101116015648.GA11534@redhat.com>	 <1289916171.5169.117.camel@maggy.simson.net>	 <1289916683.2109.625.camel@laptop>	 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>	 <20101116170312.GA19327@tango.0pointer.de> <1289930934.2109.644.camel@laptop>
In-Reply-To: <1289930934.2109.644.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79a15b89a0f8904f75945576aac70fe316350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 01:08 PM, Peter Zijlstra wrote:
> On Tue, 2010-11-16 at 18:03 +0100, Lennart Poettering wrote:
>    
>> Binding something like this to TTYs is just backwards. No graphical
>> session has a TTY attached anymore. And there might be multiple TTYs
>> used in the same session.
>>      
> Using a group per tty makes sense for us console jockeys..
>
> Anyway, nobody uses systemd yet and afaik not all distro's even plan on
> using it (I know I'm not waiting to learn yet another init variant).
>    
Right on!

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



