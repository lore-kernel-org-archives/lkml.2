Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab1CQNaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:30:21 -0400
Received: from gmmr2.centrum.cz ([90.183.38.158]:58281 "EHLO gmmr2.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1CQNaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:30:18 -0400
To: "Dave Jones" <davej@redhat.com>, "Greg KH" <greg@kroah.com>
Subject: Re: Regression from 2.6.36
Date: Thu, 17 Mar 2011 14:30:16 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>
References: <20110315132527.130FB80018F1@mail1005.cent> <20110317001519.GB18911@kroah.com> <20110317005304.GA1992@redhat.com>
In-Reply-To: <20110317005304.GA1992@redhat.com>
X-Mailer: Centrum Email 5.3
X-Priority: 3
MIME-Version: 1.0
Message-Id: <20110317143016.B94426E7@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bisecting: 5103 revisions left to test after this (roughly 12 steps)

If i'm right, it will takes 12 reboots. I'm really able to reboot only once per day and NOT during weekend so this will take 2,5 weeks.

What about that 'perf' tool ? Can anyone, please, tell me how exactly should i run it to gather usefull data ?

Thank you.

 
 ______________________________________________________________
 > Od: "Dave Jones" 
 > Komu: Greg KH 
 > Dátum: 17.03.2011 01:53
 > Predmet: Re: Regression from 2.6.36
 >
 > CC: linux-kernel@vger.kernel.org On Wed, Mar 16, 2011 at 05:15:19PM -0700, Greg Kroah-Hartman wrote: 
 
 > > Do you need any other information from me ? I'm able to try other versions or 
 > > patches but, please, take into account that I have to do this on _production_ 
 > > server (I failed to reproduce it in testing environment). Also, I'm able to try 
 > > only one kernel per day. 
 >  
 > Ick, one kernel per day might make this a bit difficult, but if there 
 > was any way you could use 'git bisect' to try to narrow this down to the 
 > patch that caused this problem, it would be great. 
 >  
 > You can mark 2.6.35 as working and 2.6.36 as bad and git will go from 
 > there and try to offer you different chances to find the problem. 
 
 Comparing the output of a perf profile between the good/bad kernels might 
 narrow it down faster than a bisect if something obvious sticks out. 
 
 Dave
