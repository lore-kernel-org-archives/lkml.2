Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1C1Xxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:53:46 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46135 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1C1Xxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:53:45 -0400
Date: Mon, 28 Mar 2011 16:53:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: advice sought: practicality of SMP cache coherency implemented
 in assembler (and a hardware detect line)
Message-ID: <20110328235338.GS2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
 <AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
 <20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
 <20110328180655.GI2287@linux.vnet.ibm.com>
 <AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
 <20110328231818.2297408f@lxorguk.ukuu.org.uk>
 <AANLkTimXztH_4f1=7-Ez6j-7UESroqwBvVuDNW7Fmewb@mail.gmail.com>
 <AANLkTinySus3129nXyDoWXnoi43FsBuxVptZ4mpf5hVJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinySus3129nXyDoWXnoi43FsBuxVptZ4mpf5hVJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:39:30AM +0100, Luke Kenneth Casson Leighton wrote:
> On Tue, Mar 29, 2011 at 12:38 AM, Luke Kenneth Casson Leighton
> <luke.leighton@gmail.com> wrote:
> 
> >  p.s. alan am not ignoring what you wrote, it's just that if this goes
> 
>  alan? beh??  paul.  sorry :)

;-)

FWIW, I believe that the http://www.scalemp.com/ folks do something
similar to what Alan suggests in order to glue multiple x86 systems into
one SMP system from the viewpoint of user applications.

							Thanx, Paul
