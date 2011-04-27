Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab1D0TTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:19:39 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:2515 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759835Ab1D0TTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:19:38 -0400
Message-ID: <4DB86BA4.8070401@draigBrady.com>
Date: Wed, 27 Apr 2011 20:16:52 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulmck@linux.vnet.ibm.com, Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
References: <20110425180450.1ede0845@neptune.home>	<BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>	<20110425190032.7904c95d@neptune.home>	<BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com>	<20110425203606.4e78246c@neptune.home>	<20110425191607.GL2468@linux.vnet.ibm.com>	<20110425231016.34b4293e@neptune.home>	<BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>	<20110425214933.GO2468@linux.vnet.ibm.com>	<20110426081904.0d2b1494@pluto.restena.lu>	<20110426112756.GF4308@linux.vnet.ibm.com>	<20110426183859.6ff6279b@neptune.home>	<20110426190918.01660ccf@neptune.home>	<BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>	<alpine.LFD.2.02.1104262314110.3323@ionos>	<20110427081501.5ba28155@pluto.restena.lu> <20110427204139.1b0ea23b@neptune.home>
In-Reply-To: <20110427204139.1b0ea23b@neptune.home>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/04/11 19:41, Bruno Prémont wrote:
> On Wed, 27 April 2011 Bruno Prémont wrote:
>> On Wed, 27 Apr 2011 00:28:37 +0200 (CEST) Thomas Gleixner wrote:
>>> On Tue, 26 Apr 2011, Linus Torvalds wrote:
>>>> On Tue, Apr 26, 2011 at 10:09 AM, Bruno Prémont wrote:
>>>>>
>>>>> Just in case, /proc/$(pidof rcu_kthread)/status shows ~20k voluntary
>>>>> context switches and exactly one non-voluntary one.
>>>>>
>>>>> In addition when rcu_kthread has stopped doing its work
>>>>> `swapoff $(swapdevice)` seems to block forever (at least normal shutdown
>>>>> blocks on disabling swap device).
> 
> Apparently it's not swapoff but `umount -a -t tmpfs` that's getting
> stuck here. Manual swapoff worked.

Anything to do with this?
http://thread.gmane.org/gmane.linux.kernel.mm/60953/

cheers,
Pádraig.
